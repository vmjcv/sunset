tool
class_name EventChainGraphEvent
extends Object

var signal_trigger_obj # 触发信号对象
var signal_before_obj # 状态改变前信号对象
var signal_after_obj # 状态改变后信号对象

enum Signal_Status {TRIGGER, BEFORE, AFTER}

func _init():
	pass
	
func set_signal(signal_status,signal_obj):
	match signal_status:
		Signal_Status.TRIGGER:
			signal_trigger_obj = signal_obj
		Signal_Status.BEFORE:
			signal_before_obj = signal_obj
		Signal_Status.AFTER:
			signal_after_obj = signal_obj
