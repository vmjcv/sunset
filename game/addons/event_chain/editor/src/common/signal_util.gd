extends Node

# 节点公用插件

var _signal_index = 0
	
func _init(index=0):
	_signal_index = index 

func get_index() -> int:
	# @:获得一个index值
	_signal_index = _signal_index + 1
	return _signal_index
