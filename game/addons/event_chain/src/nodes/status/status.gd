tool
extends EventChainNode


var _status: EventChainGraphStatus
var _status_name
var line_edit
var delete_select

func _init() -> void:
	unique_id = "status"
	display_name = "Status"
	category = "Status"
	description = "创建一个状态节点"
	
	set_input(0, "Name", EventChainGraphDataType.STRING)
	set_input(1, "Status", EventChainGraphDataType.STATUS)
	set_output(0, "Status", EventChainGraphDataType.STATUS)
	set_output(1, "StatusIndex", EventChainGraphDataType.SCALAR)

func _ready() -> void:
	connect("input_changed", self, "_on_input_changed")


func _generate_outputs() -> void:
	if _status:
		pass
	else:
		_status = get_input_single(1, null)
		if not _status:
			_status = EventChainGraphStatus.new()
	_status.status_name = get_input_single(0, "")
	_status_name = _status.status_name
	
	output[0] = _status
	output[1] = _status._index
	for i in range(2,get_inputs_count()):
		output[i] = _status


func _on_input_changed(slot: int, _value) -> void:
	_generate_outputs()


func _on_default_gui_ready() -> void:

	var center_box = HBoxContainer.new()
	center_box.name = "Center"
	center_box.size_flags_horizontal = SIZE_EXPAND_FILL
	
	var line_edit = LineEdit.new()
	line_edit.name = "LineEdit"
	line_edit.placeholder_text = "事件概述"
	line_edit.expand_to_text_length =true
	self.line_edit=line_edit
	center_box.add_child(line_edit)

	var button_add := Button.new()
	button_add.text = "增加事件"
	button_add.rect_min_size = Vector2(175, 0)
	center_box.add_child(button_add)
	button_add.connect("pressed", self, "_on_button_add_pressed")

	add_child(center_box)

	var delete_box = HBoxContainer.new()
	delete_box.name = "Delete"
	delete_box.size_flags_horizontal = SIZE_EXPAND_FILL
	
	var delete_dropdown = OptionButton.new()
	delete_dropdown.name = "OptionButton"
	
	var delete_items = {}
	for i in range(2,get_inputs_count()):
		delete_items[String(i-2)]=i

	for item in delete_items.keys():
		delete_dropdown.add_item(item)
	delete_box.add_child(delete_dropdown)
	self.delete_select=delete_dropdown

	var button_delete := Button.new()
	button_delete.text = "删除键值"
	button_delete.rect_min_size = Vector2(175, 0)
	delete_box.add_child(button_delete)
	button_delete.connect("pressed", self, "_on_button_delete_pressed")

	add_child(delete_box)

func _on_button_add_pressed() -> void:
	var count= get_inputs_count()
	set_input(count, self.line_edit.text, EventChainGraphDataType.EVENT)
	set_output(count, "", EventChainGraphDataType.STATUS)
	._generate_default_gui()
	.regenerate_default_ui()


func reset_input() -> void:
	var j=0
	for i in range(get_inputs_count()):
		if not _inputs.has(j):
			j=j+1
		_inputs[i]=_inputs[j]
		
		if i!=j:
			_inputs.erase(j)
		if i>=2:
			_outputs[i]=_outputs[j]
			if i!=j:
				_outputs.erase(j)
		j=j+1
	

func _on_button_delete_pressed() -> void:
	remove_input(self.delete_select.get_selected()+2)
	remove_output(self.delete_select.get_selected()+2)
	reset_input()
	#_setup_slots()
	._generate_default_gui()
	.regenerate_default_ui()

func get_event(name):
	for i in range(2,get_inputs_count()):
		if _inputs[i].signal_trigger_obj.signal_name==name:
			return _inputs[i]
	return null

func get_next_status(name):
	for i in range(2,get_inputs_count()):
		if _inputs[i].signal_trigger_obj.signal_name==name:
			var result: Array = get_parent().get_right_nodes(self, i)
			return result[0]
	return null

