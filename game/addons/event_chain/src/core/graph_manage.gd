tool
extends Node

# 保存所有的图数据

var _graph_dict: Dictionary

func add_graph(name,path:String):
	if _graph_dict.has(name):
		printerr("加载了相同名字的图节点两遍",name)
		return 
	var scene = load(path)
	var node = scene.instance()
	add_child(node)
	_graph_dict[name] = node
	
func remove_graph(name):
	if _graph_dict.has(name):
		var node = _graph_dict[name]
		remove_child(node)
		node.queue_free()
		_graph_dict.erase(name)

func get_graph_signal(name):
	# 返回一张图的全部信号
	var node = _graph_dict[name]
	var signal_array = node._template.get_all_signal()
	return signal_array

func get_graph_status(name):
	# 返回一张图的全部状态
	var node = _graph_dict[name]
	var status_array = node._template.get_all_status()
	return status_array

func get_all_graph_signal():
	var base_array=[]
	for key in _graph_dict:
		base_array=base_array+get_graph_signal(key)
	var base_dict={}
	for name in base_array:
		if base_dict.has(name):
			base_dict[name]=base_dict[name]+1
		else:
			base_dict[name]=1
	for key in base_dict:
		if base_dict[key]>=2 and not key.begins_with("c_") and not key.empty():
			printerr("出现重名信号且非c_开头",key)
			return 
	return base_dict

func update_all_graph(status="",signal_array=[]):
	for signal_node in signal_array:
		for key in _graph_dict:
			if status!="":
				_graph_dict[key]=status
			_graph_dict[key].event_list=[signal_node]
			_graph_dict[key]._template._run_generation()
			_graph_dict[key].event_list=[]

func get_all_graph_status():
	var base_array=[]
	for key in _graph_dict:
		base_array=base_array+get_graph_status(key)
	var base_dict={}
	for name in base_array:
		if base_dict.has(name):
			base_dict[name]=base_dict[name]+1
		else:
			base_dict[name]=1
	for key in base_dict:
		if base_dict[key]>=2 and not key.begins_with("c_"):
			printerr("出现重名状态且非c_开头",key)
			return 
	return base_dict

