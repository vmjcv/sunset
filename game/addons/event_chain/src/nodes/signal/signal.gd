tool
extends EventChainNode


var _signal: EventChainGraphSignal
var _signal_name
var key_select
var line_edit
var delete_select

func _init() -> void:
	unique_id = "signal"
	display_name = "Signal"
	category = "Signal"
	description = "创建一个信号节点"
	
	set_input(0, "Name", EventChainGraphDataType.STRING)
	set_output(0, "Signal", EventChainGraphDataType.SIGNAL)


func _ready() -> void:
	connect("input_changed", self, "_on_input_changed")


func _generate_outputs() -> void:
	if _signal:
		pass
	else:
		_signal = EventChainGraphSignal.new()
	_signal.signal_name = get_input_single(0, 0)
	_signal_name = _signal.signal_name
	for i in range(1,get_inputs_count()):
		var number = get_input_single(i, false)
		if number:
			_signal.signal_value.append(number)
	output[0] = _signal


func _on_input_changed(slot: int, _value) -> void:
	_generate_outputs()

func _on_default_gui_ready() -> void:

	var center_box = HBoxContainer.new()
	center_box.name = "Center"
	center_box.size_flags_horizontal = SIZE_EXPAND_FILL
	
	var dropdown = OptionButton.new()
	dropdown.name = "OptionButton"
	var items = {
			"Any": EventChainGraphDataType.ANY,
			"Boolean": EventChainGraphDataType.BOOLEAN,
			"Scalar": EventChainGraphDataType.SCALAR,
			"String": EventChainGraphDataType.STRING,
			#"Event": EventChainGraphDataType.EVENT,
			#"Signal": EventChainGraphDataType.SIGNAL,
			#"Status": EventChainGraphDataType.STATUS,
			}
	
	for item in items.keys():
		dropdown.add_item(item, items[item])
	center_box.add_child(dropdown)
	self.key_select=dropdown

	var line_edit = LineEdit.new()
	line_edit.name = "LineEdit"
	line_edit.placeholder_text = "键名"
	line_edit.expand_to_text_length =true
	self.line_edit=line_edit
	center_box.add_child(line_edit)

	var button_add := Button.new()
	button_add.text = "增加键值"
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
	for i in range(1,get_inputs_count()):
		delete_items[String(i)]=i

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
	match self.key_select.get_selected():
		EventChainGraphDataType.ANY:
			set_input(get_inputs_count(), self.line_edit.text, EventChainGraphDataType.ANY)
		EventChainGraphDataType.BOOLEAN:
			set_input(get_inputs_count(), self.line_edit.text, EventChainGraphDataType.BOOLEAN)
		EventChainGraphDataType.SCALAR:
			set_input(get_inputs_count(), self.line_edit.text, EventChainGraphDataType.SCALAR)
		EventChainGraphDataType.STRING:
			set_input(get_inputs_count(), self.line_edit.text, EventChainGraphDataType.STRING)
	._generate_default_gui()
	.regenerate_default_ui()


func _on_button_delete_pressed() -> void:
	remove_input(self.delete_select.get_selected()+1)
	reset_input()
	#_setup_slots()
	._generate_default_gui()
	.regenerate_default_ui()
