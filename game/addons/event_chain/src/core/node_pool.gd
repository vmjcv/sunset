tool
extends Node
class_name EventChainGraphNodePool

# 节点池，可用的节点优先从节点池中创建 

var _pools := {}


func _exit_tree() -> void:
	clear()


func get_or_create(type: GDScriptNativeClass) -> Node:
	# @:搜索未使用过的节点，如果没有的话，会创建一个新的节点
	var node
	if _pools.has(type):
		var available_nodes: Array = _pools[type]["free"]
		if available_nodes.size() == 0:
			node = type.new()
			_pools[type]["used"].append(node)
		else:
			node = available_nodes.pop_front()
			_pools[type]["used"].append(node)
	else:
		node = type.new()
		_pools[type] = {
			"free": [],
			"used": [node]
		}

	return node


func release_node(type: GDScriptNativeClass, node: Node) -> void:
	# TODO find a way to convert Node to GDScriptNativeClass or use something else to use as a key
	if not _pools.has(type):
		node.queue_free()
		return

	var used = _pools[type]["used"]
	var index = used.find(node)
	if index == -1:
		return

	node = used[index]
	used.remove(index)
	
	if node.get_parent():
		node.get_parent().remove_child(node)
	var script = node.get_script()
	if script:
		script._init()	#TODO : not sure that's enough

	_pools[type]["free"].append(node)


func release_all_nodes() -> void:
	for type in _pools.keys():
		for node in _pools[type]["used"].keys():
			release_node(type, node)

func clear() -> void:
	for key in _pools.keys():
		for key2 in _pools[key].keys():
			var p = _pools[key][key2]
			while p.size() > 0:
				var node = p.pop_front()
				if not node.get_parent():
					node.queue_free()
	_pools = {}
