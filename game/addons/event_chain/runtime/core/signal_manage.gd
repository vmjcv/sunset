"""
tool
extends Node

# 保存所有的图数据

var _graph_dict: Dictionary

func add_group(name,path:String):
	var scene = load(path)
	var node = scene.instance()
	add_child(node)
	pass

func register_all_signals():
	var signal_dict = EventChainGraphManage.get_all_graph_signal()
	for key in signal_dict:
		if not key.empty():
			add_user_signal(key)
			connect(key,self,"_get_signal",[key])

func _get_signal(key):
	EventChainGraphManage.update_all_graph("",[key])

func emit(name,data=[]):
	# @:脚本给图发射触发信号
	if data.size()==0:
		emit_signal(name)
	else:
		emit_signal(name,data)


func connect_signal(name,node,callback):
	# @:主要是注册转换前和转换后回调使用
	connect(name,node,callback)
"""
