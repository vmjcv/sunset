tool
class_name EventChainNode
extends GraphNode

# 图形编辑器基础节点

signal delete_node
signal node_changed
signal input_changed
signal connection_changed


var unique_id := "event_chain_node"
var display_name := "EventChainNode"
var category := "No category"
var description := "节点功能的简要说明"
var node_pool: EventChainGraphNodePool # Injected from template
var output := []
var minimap_color
# 是否需要强制重新生成ui
var requires_full_gui_rebuild := false

var _folder_icon
var _multi_input_icon
var _spinbox

var _inputs := {}
var _outputs := {}
var _hboxes := []
var _resize_timer := Timer.new()
var _file_dialog: FileDialog
var _initialized := false	# 当enter_tree完成后未True
var _generation_requested := false # 调用一次准备输出后为True
var _output_ready := false # 当输出完成后返回True


func _enter_tree() -> void:
	if _initialized:
		return

	_generate_default_gui()
	_setup_slots()

	_resize_timer.one_shot = true
	_resize_timer.autostart = false
	add_child(_resize_timer)

	_connect_signals()
	_reset_output()
	_initialized = true


func has_custom_gui() -> bool:
	# @:如果应直接从场景中实例化节点，则重写并将其返回True。scene应该与脚本具有相同的名称，并使用.tscn扩展名。使用自定义GUI时，将无法访问默认GUI,您必须定义插槽，重做，撤销操作，但是可以完全控制节点的外观和行为。
	return false


func is_output_ready() -> bool:
	return _output_ready


func is_final_output_node() -> bool:
	# @:如果该节点标记为结尾节点，则返回True
	return false


func get_inputs_count() -> int:
	# @:返回此节点上可用的总输入槽数，包括动态节点
	return _inputs.size()



func get_input(idx: int, default = []) -> Array:
	# @:从插槽索引返回关联数据，可以来自连接的输入节点，或在简单类型的情况下从本地访问。
	var parent = get_parent()
	if not parent:
		return default

	var inputs: Array = parent.get_left_nodes(self, idx)
	if inputs.size() > 0: # 有输入节点的时候忽略本地数据
		var res = []
		for input in inputs:
			var node_output = input["node"].get_output(input["slot"], default)
			if node_output is Array:
				res += node_output
			else:
				res.append(node_output)
		return res

	if has_custom_gui():
		var node_output = _get_input(idx)
		if node_output == null:
			return default
		return node_output

	var local_value = _get_default_gui_value(idx) # 如果为连接任何源，检查是否在节点本身定义了值
	if local_value != null:
		return [local_value]

	return default


func get_input_single(idx: int, default = null):
	# @:默认情况下，每个输入和输出都是一个数组。这个函数用来返回第一个值
	var input = get_input(idx)
	if input == null or input.size() == 0 or input[0] == null:
		return default
	return input[0]


func get_output(idx: int, default := []) -> Array:
	# @:返回节点为给定插槽生成的内容，此方法确保每次运行计算的输出不超过一次。节省性能
	if not is_output_ready():
		_generate_outputs()
		_output_ready = true

	if output.size() < idx + 1:
		return default

	var res = output[idx]
	if not res is Array:
		res = [res]
	if res.size() == 0:
		return default

	# 如果输出是节点数组，则需要首先复制它们，否则它们将作为引用，将相同的输出发送到两个不同的节点会导致问题
	if res[0] is Object and res[0].has_method("duplicate"):
		var duplicates = []
		for i in res.size():
			# TODO move the duplication in a helper function instead
			var node = res[i]
			var duplicate = node.duplicate(7)

			# 最终输出节点的内容由EventChainGraph负责
			if not is_final_output_node():
				register_to_garbage_collection(duplicate)

			duplicates.append(duplicate)
		return duplicates

	# 如果不是节点数组，则它包含内置类型或者嵌套数组。数组作为参考传递，因此返回深层副本
	return res.duplicate(true)


func get_editor_input(name: String) -> Node:
	# @:在编辑器中查询输入节点
	var parent = get_parent()
	if not parent:
		return null
	var input = parent.event_chain_graph.get_input(name)
	if input == null:
		return null

	var input_copy = input.duplicate(7)
	register_to_garbage_collection(input_copy)
	return input_copy


func get_exposed_variables() -> Array:
	# @:返回暴露给节点检查器的变量，与get_property_list相同的格式[{name：，type：}，...]
	return []


func get_event_chain_graph():
	return get_parent().event_chain_graph


func reset() -> void:
	# @:清除缓存以及与此几点相关的每个节点的缓存
	clear_cache()
	for node in get_parent().get_all_right_nodes(self):
		node.reset()


func clear_cache() -> void:
	_clear_cache()
	_reset_output()
	_output_ready = false


func export_editor_data() -> Dictionary:
	var editor_scale = EventChainGraphEditorUtil.get_dpi_scale()
	var data = {}
	data["offset_x"] = offset.x / editor_scale
	data["offset_y"] = offset.y / editor_scale

	if resizable:
		data["rect_x"] = rect_size.x
		data["rect_y"] = rect_size.y

	data["slots"] = {}
	for i in _inputs.size():
		var idx = String(i) # 调用恢复时需要修复不一致
		var local_value = _get_default_gui_value(i, true)
		if local_value != null:
			data["slots"][idx] = local_value

	return data


func restore_editor_data(data: Dictionary) -> void:
	var editor_scale = EventChainGraphEditorUtil.get_dpi_scale()
	offset.x = data["offset_x"] * editor_scale
	offset.y = data["offset_y"] * editor_scale

	if data.has("rect_x"):
		rect_size.x = data["rect_x"]
	if data.has("rect_y"):
		rect_size.y = data["rect_y"]
	emit_signal("resize_request", rect_size)

	if has_custom_gui():
		return

	var slots = _hboxes.size()

	for i in slots:
		if data["slots"].has(String(i)):
			var type = _inputs[i]["type"]
			var value = data["slots"][String(i)]
			var left = _hboxes[i].get_node("Left")

			match type:
				EventChainGraphDataType.BOOLEAN:
					left.get_node("CheckBox").pressed = value
				EventChainGraphDataType.SCALAR:
					left.get_node("SpinBox").value = value
				EventChainGraphDataType.STRING:
					if left.has_node("LineEdit"):
						left.get_node("LineEdit").text = value
					elif left.has_node("OptionButton"):
						var btn: OptionButton = left.get_node("OptionButton")
						btn.selected = btn.get_item_index(int(value))


func export_custom_data() -> Dictionary:
	# @:将树的信息保存到json文件中，每个节点显示指定数据保存。大多数节点不需要它
	return {}



func restore_custom_data(_data: Dictionary) -> void:
	# @:使用export_custom_data的数据来进行恢复先前的节点状态
	pass


func is_input_connected(idx: int) -> bool:
	var parent = get_parent()
	if not parent:
		return false

	return parent.is_node_connected_to_input(self, idx)

func is_output_connected(idx: int) -> bool:
	var parent = get_parent()
	if not parent:
		return false

	return parent.is_node_connected_to_output(self, idx)

func set_input(idx: int, name: String, type: int, opts: Dictionary = {}) -> void:
	_inputs[idx] = {
		"name": name,
		"type": type,
		"options": opts,
		"mirror": [],
		"driver": -1,
		"linked": [],
		"multi": false
	}

func reset_input() -> void:
	var j=0
	for i in range(get_inputs_count()):
		if not _inputs.has(j):
			j=j+1
		_inputs[i]=_inputs[j]
		if i!=j:
			_inputs.erase(j)
		j=j+1
	


func set_output(idx: int, name: String, type: int, opts: Dictionary = {}) -> void:
	_outputs[idx] = {
		"name": name,
		"type": type,
		"options": opts
	}


func remove_input(idx: int) -> bool:
	if not _inputs.erase(idx):
		return false

	if is_input_connected(idx):
		get_parent()._disconnect_input(self, idx)
	return true

func remove_output(idx: int) -> bool:
	if not _outputs.erase(idx):
		return false

	if is_output_connected(idx):
		get_parent()._disconnect_output(self, idx)
	return true


func mirror_slots_type(input_index, output_index) -> void:
	# @:自动更改输出类型以镜像与输入插槽连接的类型
	if not _mirror_type_check(input_index, output_index):
		return

	_inputs[input_index]["mirror"].append(output_index)
	_inputs[input_index]["default_type"] = _inputs[input_index]["type"]
	_update_slots_types()


func cancel_type_mirroring(input_index, output_index) -> void:
	# @:取消类型镜像
	if not _mirror_type_check(input_index, output_index):
		return

	_inputs[input_index]["mirror"].erase(output_index)
	_update_slots_types()


func enable_multiple_connections_on_slot(idx: int) -> void:
	# @: 允许在同一个输入插槽上进行多个连接
	if idx >= _inputs.size():
		return
	_inputs[idx]["multi"] = true


func is_multiple_connections_enabled_on_slot(idx: int) -> bool:
	if idx >= _inputs.size():
		return false
	return _inputs[idx]["multi"]



func set_value_from_inspector(_name: String, _value) -> void:
	# @:将数据暴露给检查器时，重写此方法。决定如何处理用户定义的值
	pass


func register_to_garbage_collection(resource):
	get_parent().register_to_garbage_collection(resource)


func regenerate_default_ui():
	# @:重新创建用户界面，因为node是在空间中生成，无法访问主题
	if has_custom_gui():
		return

	var editor_data = export_editor_data()
	var custom_data = export_custom_data()
	_generate_default_gui()
	restore_editor_data(editor_data)
	restore_custom_data(custom_data)
	_setup_slots()


func _get_connected_inputs() -> Array:
	# @:返回连接到该节点的每个节点
	var connected_inputs = []
	for i in _inputs.size():
		var nodes: Array = get_parent().get_left_nodes(self, i)
		for data in nodes:
			connected_inputs.append(data["node"])
	return connected_inputs


func _generate_outputs() -> void:
	# @:在派生类中重写此函数已返回可用的东西，为每个输出插槽生成所有输出
	pass


func _get_input(_index: int) -> Array:
	# @:如果使用自定义gui更改插槽的默认行为，覆盖此函数
	# @return:返回给定插槽的本地输入数据
	return []



func _clear_cache():
	# @:自定义如何清除缓存
	pass


func _reset_output():
	# @:清除输出，并创建与图节点中的输出插槽一样多的空数组
	for slot in output:
		if slot is Array:
			for res in slot:
				if res is Node:
					res.queue_free()
		elif slot is Node:
			slot.queue_free()

	output = []
	for i in _outputs.size():
		output.append([])


func _mirror_type_check(input_index, output_index) -> bool:
	# @:用于mirror_slot_types和cancel_slot_types，如果提供的插槽超出范围，则报错
	if input_index >= _inputs.size():
		print("Error: invalid input index (", input_index, ") passed to ", display_name)
		return false

	if output_index >= _outputs.size():
		print("Error: invalid output index (", input_index, ") passed to ", display_name)
		return false

	return true


func _setup_slots() -> void:
	# @:基于之前对set_input和set_ouput的调用，此方法将适当的参数相应调用GraphNode.set_slot方法
	var slots = _hboxes.size()
	for i in slots + 1:	# +1的目的是防止在移除输入时使额外的插槽处于活动状态
		var has_input := false
		var input_type := 0
		var input_color := Color(0)
		var has_output := false
		var output_type := 0
		var output_color := Color(0)
		var icon = null

		if _inputs.has(i):
			has_input = true
			var driver = _inputs[i]["driver"]
			if driver != -1:
				input_type = _inputs[driver]["type"]
			else:
				input_type = _inputs[i]["type"]
			input_color = EventChainGraphDataType.COLORS[input_type]
			if _inputs[i]["multi"]:
				# 多输入节点给一个变淡的icon
				icon = EventChainGraphEditorUtil.get_square_texture(input_color.lightened(0.6))
		if _outputs.has(i):
			has_output = true
			output_type = _outputs[i]["type"]
			output_color = EventChainGraphDataType.COLORS[output_type]

		if not has_input and not has_output and i < _hboxes.size():
			_hboxes[i].visible = false

		set_slot(i, has_input, input_type, input_color, has_output, output_type, output_color, icon)

	# 删除不匹配的节点
	for b in _hboxes:
		if not b.visible:
			_hboxes.erase(b)
			remove_child(b)

	if not resizable:
		emit_signal("resize_request", Vector2(rect_min_size.x, 0.0))


func _clear_gui() -> void:
	_hboxes = []
	for child in get_children():
		if child is Control:
			remove_child(child)
			child.queue_free()


func _generate_default_gui_style() -> void:
	# @:基于图节点类别，设置图节点的样式和颜色
	var scale: float = EventChainGraphEditorUtil.get_dpi_scale()

	# Base Style
	var style = StyleBoxFlat.new()
	var color = Color(0.121569, 0.145098, 0.192157, 0.9)
	style.border_color = EventChainGraphDataType.to_category_color(category)
	minimap_color = style.border_color
	style.set_bg_color(color)
	style.set_border_width_all(2 * scale)
	style.set_border_width(MARGIN_TOP, 32 * scale)
	style.content_margin_left = 24 * scale;
	style.content_margin_right = 24 * scale;
	style.set_corner_radius_all(4 * scale)
	style.set_expand_margin_all(4 * scale)
	style.shadow_size = 8 * scale
	style.shadow_color = Color(0, 0, 0, 0.2)

	# Selected Style
	var selected_style = style.duplicate()
	selected_style.shadow_color = EventChainGraphDataType.to_category_color(category)
	selected_style.shadow_size = 4 * scale
	selected_style.border_color = Color(0.121569, 0.145098, 0.192157, 0.9)

	if not comment:
		add_stylebox_override("frame", style)
		add_stylebox_override("selectedframe", selected_style)
	else:
		style.set_bg_color(Color("0a4371b5"))
		style.content_margin_top = 40 * scale
		add_stylebox_override("comment", style)
		add_stylebox_override("commentfocus", selected_style)

	add_constant_override("port_offset", 12 * scale)
	add_font_override("title_font", get_font("bold", "EditorFonts"))


func _generate_default_gui() -> void:
	# @:如果未自定义ui则通过这个方法创建默认ui。输入插槽将根据其类型具有其他UI元素。标量输入会得到一个旋转框，当某些东西连接到插槽时，该旋转框将隐藏。存储在旋转框中的值将自动导出并恢复。
	if has_custom_gui():
		return

	_clear_gui()
	_generate_default_gui_style()

	title = display_name
	show_close = true
	rect_min_size = Vector2(0.0, 0.0)
	rect_size = Vector2(0.0, 0.0)
	var max_output_label_length := 0

	var slots = max(_inputs.size(), _outputs.size())
	for i in slots:
		# Create a Hbox container per slot like this -> [LabelIn, (opt), LabelOut]
		var hbox = HBoxContainer.new()
		hbox.rect_min_size.y = 24

		# Make sure it appears in the editor and store along the other Hboxes
		_hboxes.append(hbox)
		add_child(hbox)

		var left_box = HBoxContainer.new()
		left_box.name = "Left"
		left_box.size_flags_horizontal = SIZE_EXPAND_FILL
		hbox.add_child(left_box)

		# label_left holds the name of the input slot.
		var label_left = Label.new()
		label_left.name = "LabelLeft"
		label_left.mouse_filter = MOUSE_FILTER_PASS
		left_box.add_child(label_left)

		# If this slot has an input
		if _inputs.has(i):
			label_left.text = _inputs[i]["name"]
			label_left.hint_tooltip = EventChainGraphDataType.Types.keys()[_inputs[i]["type"]].capitalize()

			# Add the optional UI elements based on the data type.
			# TODO : We could probably just check if the property exists with get_property_list
			# and do that automatically instead of manually setting everything one by one
			match _inputs[i]["type"]:
				EventChainGraphDataType.BOOLEAN:
					var opts = _inputs[i]["options"]
					var checkbox = CheckBox.new()
					checkbox.name = "CheckBox"
					checkbox.pressed = opts["value"] if opts.has("value") else false
					checkbox.connect("toggled", self, "_on_default_gui_value_changed", [i])
					checkbox.connect("toggled", self, "_on_default_gui_interaction", [checkbox, i])
					left_box.add_child(checkbox)

				EventChainGraphDataType.SCALAR:
					var opts = _inputs[i]["options"]
					var n = _inputs[i]["name"]
					_create_spinbox(n, opts, left_box, i)
					label_left.visible = false

					var rx = n.length() * 18.0
					if rect_min_size.x < rx:
						rect_min_size.x = rx

				EventChainGraphDataType.STRING:
					var opts = _inputs[i]["options"]
					if opts.has("type") and opts["type"] == "dropdown":
						var dropdown = OptionButton.new()
						dropdown.name = "OptionButton"
						for item in opts["items"].keys():
							dropdown.add_item(item, opts["items"][item])
						dropdown.connect("item_selected", self, "_on_default_gui_value_changed", [i])
						dropdown.connect("item_selected", self, "_on_default_gui_interaction", [dropdown, i])
						left_box.add_child(dropdown)
						requires_full_gui_rebuild = true
					else:
						var line_edit = LineEdit.new()
						line_edit.name = "LineEdit"
						line_edit.placeholder_text = opts["placeholder"] if opts.has("placeholder") else "Text"
						line_edit.expand_to_text_length = opts["expand"] if opts.has("expand") else true
						line_edit.connect("text_changed", self, "_on_default_gui_value_changed", [i])
						line_edit.connect("text_changed", self, "_on_default_gui_interaction", [line_edit, i])
						left_box.add_child(line_edit)

						if opts.has("file_dialog"):
							var folder_button = Button.new()
							if not _folder_icon:
								_folder_icon = load(EventChainGraphEditorUtil.get_plugin_root_path() + "icons/icon_folder.svg")
							folder_button.icon = _folder_icon
							folder_button.connect("pressed", self, "_show_file_dialog", [opts["file_dialog"], line_edit])
							left_box.add_child(folder_button)



		var label_right = Label.new()
		label_right.name = "LabelRight"
		label_right.mouse_filter = MOUSE_FILTER_PASS
		label_right.size_flags_horizontal = SIZE_FILL
		label_right.align = Label.ALIGN_RIGHT
		label_right.visible = false

		if _outputs.has(i):
			label_right.text = _outputs[i]["name"]
			if label_right.text.length() > max_output_label_length:
				max_output_label_length = label_left.text.length()
			label_right.hint_tooltip = EventChainGraphDataType.Types.keys()[_outputs[i]["type"]].capitalize()
			if label_right.text != "":
				label_right.visible = true
		hbox.add_child(label_right)

	rect_min_size.x += max_output_label_length * 6.0 # TODO; tmp hack, use editor scale here and find a better layout
	_on_connection_changed()
	_on_default_gui_ready()
	_redraw()


func _create_spinbox(property_name, opts, parent, idx) -> SpinBox:
	if not _spinbox:
		_spinbox = load(EventChainGraphEditorUtil.get_plugin_root_path() + "/src/editor/gui/spinbox.tscn")
	var spinbox = _spinbox.instance()
	if parent:
		parent.add_child(spinbox)
	spinbox.set_label_value(property_name)
	spinbox.name = "SpinBox"
	spinbox.max_value = opts["max"] if opts.has("max") else 1000
	spinbox.min_value = opts["min"] if opts.has("min") else 0
	spinbox.value = opts["value"] if opts.has("value") else 0
	spinbox.step = opts["step"] if opts.has("step") else 0.001
	spinbox.exp_edit = opts["exp"] if opts.has("exp") else false
	spinbox.allow_greater = opts["allow_greater"] if opts.has("allow_greater") else true
	spinbox.allow_lesser = opts["allow_lesser"] if opts.has("allow_lesser") else true
	spinbox.rounded = opts["rounded"] if opts.has("rounded") else false
	spinbox.connect("value_changed", self, "_on_default_gui_value_changed", [idx])
	spinbox.connect("value_changed", self, "_on_default_gui_interaction", [spinbox, idx])
	return spinbox
	

func _get_default_gui_value(idx: int, for_export := false):
	var left = _hboxes[idx].get_node("Left")
	if not left:
		return null

	match _inputs[idx]["type"]:
		EventChainGraphDataType.BOOLEAN:
			if left.has_node("CheckBox"):
				return left.get_node("CheckBox").pressed
		EventChainGraphDataType.SCALAR:
			if left.has_node("SpinBox"):
				return left.get_node("SpinBox").value
		EventChainGraphDataType.STRING:
			if left.has_node("LineEdit"):
				return left.get_node("LineEdit").text
			elif left.has_node("OptionButton"):
				var btn = left.get_node("OptionButton")
				if for_export:
					return btn.get_item_id(btn.selected)
				else:
					return btn.get_item_text(btn.selected)
		
	return null



func _redraw() -> void:
	# @:强制GraphNode重绘其gui，主要时为了在调整大小后修复连接
	if not resizable:
		emit_signal("resize_request", Vector2(rect_min_size.x, 0.0))
	if get_parent():
		get_parent().force_redraw()
	else:
		hide()
		show()


func _connect_signals() -> void:
	connect("close_request", self, "_on_close_request")
	connect("resize_request", self, "_on_resize_request")
	connect("connection_changed", self, "_on_connection_changed")
	_resize_timer.connect("timeout", self, "_on_resize_timeout")



func _show_file_dialog(opts: Dictionary, line_edit: LineEdit) -> void:
	# @:显示一个FileDialg窗口，并将所选文件路径写入line_edit
	if not _file_dialog:
		_file_dialog = FileDialog.new()
		add_child(_file_dialog)

	_file_dialog.rect_min_size = Vector2(500, 500)
	_file_dialog.mode = opts["mode"] if opts.has("mode") else FileDialog.MODE_SAVE_FILE
	_file_dialog.resizable = true

	if opts.has("filters"):
		var filters = PoolStringArray()
		for filter in opts["filters"]:
			filters.append(filter)
		_file_dialog.set_filters(filters)

	if _file_dialog.is_connected("confirmed", self, "_on_file_selected"):
		_file_dialog.disconnect("confirmed", self, "_on_file_selected")
	_file_dialog.connect("confirmed", self, "_on_file_selected", [line_edit])
	_file_dialog.popup_centered()


func _update_slots_types() -> void:
	# 如果开启了镜像选项，则更改插槽类型
	var slots_types_updated = false

	for i in _inputs.size():
		for o in _inputs[i]["mirror"]:
			slots_types_updated = true
			var type = _inputs[i]["default_type"]

			# Copy the connected input type if there is one but if multi connection is enabled,
			# all connected inputs must share the same type otherwise it will use the default type.
			if is_input_connected(i):
				var inputs: Array = get_parent().get_left_nodes(self, i)
				var input_type = -1

				for data in inputs:
					if input_type == -1:
						input_type = data["node"]._outputs[data["slot"]]["type"]
					else:
						if data["node"]._outputs[data["slot"]]["type"] != input_type:
							input_type = -2
				if input_type >= 0:
					type = input_type

			_inputs[i]["type"] = type
			_outputs[o]["type"] = type

	if slots_types_updated:
		_setup_slots()
		# Propagate the type change to the connected nodes
		var parent = get_parent()
		if parent:
			for node in parent.get_all_right_nodes(self):
				node.emit_signal("connection_changed")


func _on_file_selected(line_edit: LineEdit) -> void:
	line_edit.text = _file_dialog.current_path


func _on_resize_request(new_size) -> void:
	rect_size = new_size
	if resizable:
		_resize_timer.start(2.0)


func _on_resize_timeout() -> void:
	emit_signal("node_changed", self, false)


func _on_close_request() -> void:
	emit_signal("delete_node", self)



func _on_connection_changed() -> void:
	# 存在连接，则隐藏默认ui
	for i in _inputs.size():
		var type = _inputs[i]["type"]
		for ui in _hboxes[i].get_node("Left").get_children():
			if not ui is Label:
				ui.visible = !is_input_connected(i)
			elif ui.name == "LabelLeft":
				ui.visible = true
				if type == EventChainGraphDataType.SCALAR:
					ui.visible = is_input_connected(i)

	_update_slots_types()
	_redraw()



func _on_default_gui_ready():
	# @:如果要再默认ui上创建自定义ui，则覆盖此方法
	pass


func _on_default_gui_value_changed(value, slot: int) -> void:
	emit_signal("node_changed", self, true)
	emit_signal("input_changed", slot, value)
	reset()


func _on_default_gui_interaction(_value, _control: Control, _slot: int) -> void:
	pass
