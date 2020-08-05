tool
class_name EventChainGraphSignal
extends Object

export var signal_name: String
export var signal_value: Array

var _index: int 

func _init():
	_index = SignalUtils.get_index()
