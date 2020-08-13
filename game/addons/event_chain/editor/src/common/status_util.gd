extends Node

# 节点公用插件

var _status_index = 0
	
func _init(index=0):
	_status_index = index 

func get_index() -> int:
	# @:获得一个index值
	_status_index = _status_index + 1
	return _status_index
