tool
extends EventChainNode


var _event: EventChainGraphEvent
var _event_name


func _init() -> void:
	unique_id = "event"
	display_name = "Event"
	category = "Event"
	description = "创建一个事件节点"
	
	set_input(0, "Trigger", EventChainGraphDataType.SIGNAL)
	set_input(1, "Before", EventChainGraphDataType.SIGNAL)
	set_input(2, "After", EventChainGraphDataType.SIGNAL)
	set_output(0, "Event", EventChainGraphDataType.EVENT)


func _ready() -> void:
	connect("input_changed", self, "_on_input_changed")


func _generate_outputs() -> void:
	_event = EventChainGraphEvent.new()
	_event.signal_trigger_obj = get_input_single(0, 0)
	_event.signal_before_obj = get_input_single(1, 0)
	_event.signal_after_obj = get_input_single(2, 0)

	output[0] = _event


func _on_input_changed(slot: int, _value) -> void:
	_generate_outputs()


