tool
class_name EventChainGraphStatus
extends Object

export var status_name: String = ""
var _index: int 

func _init():
	_index = StatusUtils.get_index()

