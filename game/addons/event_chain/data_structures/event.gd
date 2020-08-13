# 事件类，封装触发信号，状态改变前信号，状态改变后信号，触发回调数组
tool
class_name EventChainGraphEvent
extends Object

var signal_trigger_obj # 触发信号对象
var signal_before_obj # 状态改变前信号对象
var signal_after_obj # 状态改变后信号对象

var callback_table: Array = []# 状态改变得callback表

enum Signal_Status {TRIGGER, BEFORE, AFTER}
	
func set_signal(signal_status,signal_obj):
	match signal_status:
		Signal_Status.TRIGGER:
			signal_trigger_obj = signal_obj
		Signal_Status.BEFORE:
			signal_before_obj = signal_obj
		Signal_Status.AFTER:
			signal_after_obj = signal_obj

func set_callback(table):
	callback_table = table
	
func add_callback(callback):
	callback_table.append(callback)
