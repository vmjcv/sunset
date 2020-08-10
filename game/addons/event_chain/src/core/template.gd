tool
class_name EventChainGraphTemplate
extends "custom_graph_edit.gd"

# 图形编辑器节点，基类负责处理所有和引擎的交互

signal simulation_started # 模拟开始
signal simulation_outdated # 模拟超时
signal simulation_completed # 模拟结束
signal completed
signal json_ready


var event_chain_graph
var node_library: EventChainNodeLibrary	# Injected from the concept graph

var _json_util = load(EventChainGraphEditorUtil.get_plugin_root_path() + "/src/thirdparty/json_beautifier/json_beautifier.gd")
var _node_pool := EventChainGraphNodePool.new()
var _save_thread: Thread
var _save_queued := false

var _template_loaded := false
var _clear_cache_on_next_run := false
var _registered_resources := [] # References to Objects needing garbage collection


func _init() -> void:
	connect("completed", self, "_on_completed")

func clear() -> void:
	_template_loaded = false
	clear_editor()
	run_garbage_collection()


func create_node(node: EventChainNode, data := {}, notify := true) -> EventChainNode:
	var new_node: EventChainNode = node.duplicate()
	if data.has("offset"):
		new_node.offset = data["offset"]
	else:
		new_node.offset = scroll_offset + Vector2(250, 150)

	
	add_child(new_node)
	_connect_node_signals(new_node)
	
	
	
	if data.has("name"):
		new_node.name = data["name"]
	if data.has("editor"):
		new_node.restore_editor_data(data["editor"])
	if data.has("data"):
		new_node.restore_custom_data(data["data"])

	if notify:
		emit_signal("graph_changed")
		emit_signal("simulation_outdated")
	return new_node


func duplicate_node(node: EventChainNode) -> GraphNode:
	var ref = node_library.create_node(node.unique_id)
	ref.restore_editor_data(node.export_editor_data())
	ref.restore_custom_data(node.export_custom_data())
	return ref


func update_exposed_variables() -> void:
	var exposed_variables = []
	for c in get_children():
		if c is EventChainNode:
			var variables = c.get_exposed_variables()
			if not variables:
				continue
			for v in variables:
				v.name = "Template/" + v.name
				v.type = EventChainGraphDataType.to_variant_type(v.type)
				exposed_variables.append(v)

	event_chain_graph.update_exposed_variables(exposed_variables)


func get_value_from_inspector(name: String):
	return event_chain_graph.get("Template/" + name)


func clear_simulation_cache() -> void:
	# @:清除每个节点的缓存
	for node in get_children():
		if node is EventChainNode:
			node.clear_cache()
	run_garbage_collection()
	_clear_cache_on_next_run = false


func generate(force_full_simulation := false) -> void:
	_clear_cache_on_next_run = _clear_cache_on_next_run or force_full_simulation
	emit_signal("simulation_started")
	_run_generation()


func load_from_file(path: String, soft_load := false) -> void:
	
	if not node_library or not path or path == "":
		return

	_template_loaded = false
	if soft_load:	# Don't clear, simply refresh the graph edit UI without running the sim
		clear_editor()
	else:
		clear()

	# Open the file and read the contents
	var file = File.new()
	file.open(path, File.READ)
	var json = JSON.parse(file.get_as_text())
	if not json or not json.result:
		print("Failed to parse json")
		return	# Template file is either empty or not a valid Json. Ignore

	# Abort if the file doesn't have node data
	var graph: Dictionary = json.result
	if not graph.has("nodes"):
		return

	# For each node found in the template file
	var node_list = node_library.get_list()
	for node_data in graph["nodes"]:
		if not node_data.has("type"):
			continue

		var type = node_data["type"]
		if not node_list.has(type):
			print("Error: Node type ", type, " could not be found.")
			continue

		# Get a graph node from the node_library and use it as a model to create a new one
		var node_instance = node_list[type]
		create_node(node_instance, node_data, false)

	for c in graph["connections"]:
		# TODO: convert the to/from ports stored in file to actual port
		connect_node(c["from"], c["from_port"], c["to"], c["to_port"])
		get_node(c["to"]).emit_signal("connection_changed")

	_template_loaded = true


func save_to_file(path: String) -> void:
	var graph := {}
	# TODO : Convert the connection_list to an ID connection list
	graph["connections"] = get_connection_list()
	graph["nodes"] = []

	for c in get_children():
		if c is EventChainNode:
			var node = {}
			node["name"] = c.get_name()
			node["type"] = c.unique_id
			node["editor"] = c.export_editor_data()
			node["data"] = c.export_custom_data()
			graph["nodes"].append(node)

	if not _save_thread:
		_save_thread = Thread.new()

	if _save_thread.is_active():
		_save_queued = true
		return

	_save_thread.start(self, "_beautify_json", to_json(graph))

	yield(self, "json_ready")

	var json = _save_thread.wait_to_finish()
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string(json)
	file.close()

	if _save_queued:
		_save_queued = false
		save_to_file(path)


func register_to_garbage_collection(resource):
	if resource is Object and not resource is Reference:
		_registered_resources.append(weakref(resource))


func run_garbage_collection():
	for res in _registered_resources:
		var resource = res.get_ref()
		if resource:
			if resource is Node:
				var parent = resource.get_parent()
				if parent:
					parent.remove_child(resource)
				resource.queue_free()
			elif resource is Object:
				resource.call_deferred("free")
	_registered_resources = []

func get_status(name):
	if name:
		for node in get_children():
			if node is EventChainNode and node.unique_id=="status":
				node._generate_outputs()
				if node.output[0].status_name==name:
					return node
	return null
	
func get_all_signal():
	var signal_array=[]
	for node in get_children():
		if node is EventChainNode and node.unique_id=="signal":
			node._generate_outputs()
			signal_array.append(node._signal_name)
	return signal_array
	
func get_all_status():
	var status_array=[]
	for node in get_children():
		if node is EventChainNode and node.unique_id=="status":
			node._generate_outputs()
			status_array.append(node._status_name)
	return status_array


func _run_generation() -> void:
	if _clear_cache_on_next_run:
		clear_simulation_cache()
	var node = get_status(event_chain_graph.now_status)
	if node and event_chain_graph.event_list.size()>0:
		var event = node.get_event(event_chain_graph.event_list[0])
		if event:
			if event.signal_before_obj:
				EventChainSignalManage.emit(event.signal_before_obj.name,event.signal_before_obj.signal_value)
		var next_status = node.get_next_status(event_chain_graph.event_list[0])
		if next_status:
			event_chain_graph.now_status = next_status.status_name
		if event:
			if event.signal_after_obj:
				EventChainSignalManage.emit(event.signal_after_obj.name,event.signal_after_obj.signal_value)
			
	call_deferred("emit_signal", "completed")

func _call_signal(obj):
	pass

func _beautify_json(json: String) -> String:
	var res = _json_util.beautify_json(json)
	call_deferred("emit_signal", "json_ready")
	return res


func _on_completed() -> void:
	emit_signal("simulation_completed")


func _on_node_changed_zero():
	_on_node_changed(null, false)

func _on_node_changed(_node: EventChainNode, replay_simulation := false) -> void:
	# Prevent regeneration hell while loading the template from file
	if not _template_loaded:
		return

	emit_signal("graph_changed")
	if replay_simulation:
		emit_signal("simulation_outdated")
	update()

