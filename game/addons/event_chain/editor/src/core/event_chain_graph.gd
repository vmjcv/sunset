tool
class_name EventChainGraph, "../../icons/icon_event_chain_graph.svg"
extends Node

# 事件链图，在节点树中出现

signal template_path_changed


export(String, FILE, "*.egraph") var template_path := "" setget set_template_path
export var auto_generate_on_load := true

var _initialized := false
var _template: EventChainGraphTemplate
var _exposed_variables := {}

export var now_status:String
export var event_list:Array

func _enter_tree():
	# @:进入场景的时候重播所有事件信号
	if _initialized:
		return
	if Engine.is_editor_hint():
		reload_template(auto_generate_on_load)
	_initialized = true


func _get_property_list() -> Array:
	# @:属性列表中的信息
	var res := []
	for name in _exposed_variables.keys():
		var dict := {
			"name": name,
			"type": _exposed_variables[name]["type"],
		}
		if _exposed_variables[name].has("hint"):
			dict["hint"] = _exposed_variables[name]["hint"]
		if _exposed_variables[name].has("hint_string"):
			dict["hint_string"] = _exposed_variables[name]["hint_string"]
		res.append(dict)
	return res


func _get(property):
	if _exposed_variables.has(property):
		if _exposed_variables[property].has("value"):
			return _exposed_variables[property]["value"]


func _set(property, value): # overridden
	if property.begins_with("Template/"):
		if _exposed_variables.has(property):
			_exposed_variables[property]["value"] = value
			generate(true)
		else:
			# This happens when loading the scene, don't regenerate here as it will happen again
			# in _enter_tree
			_exposed_variables[property] = {"value": value}

			if value is float:
				_exposed_variables[property]["type"] = TYPE_REAL
			elif value is String:
				_exposed_variables[property]["type"] = TYPE_STRING
			elif value is bool:
				_exposed_variables[property]["type"] = TYPE_BOOL
			elif value is int:
				_exposed_variables[property]["type"] = TYPE_INT
			property_list_changed_notify()
		return true
	return false


func update_exposed_variables(variables: Array) -> void:
	var old = _exposed_variables
	_exposed_variables = {}

	for v in variables:
		if _exposed_variables.has(v.name):
			continue

		var value = old[v.name]["value"] if old.has(v.name) else v["default_value"]
		_exposed_variables[v.name] = {
			"type": v["type"],
			"value": value,
		}
		if v.has("hint"):
			_exposed_variables[v.name]["hint"] = v["hint"]
		if v.has("hint_string"):
			_exposed_variables[v.name]["hint_string"] = v["hint_string"]
	property_list_changed_notify()


func reload_template(generate: bool = true) -> void:
	if not _template:
		_template = EventChainGraphTemplate.new()
		add_child(_template)
		_template.event_chain_graph = self
		
		_template.node_library = get_tree().root.get_node_or_null("EventChainNodeLibrary")
		if _template.node_library==null:
			var _node_library = EventChainNodeLibrary.new()
			_node_library.name = "EventChainNodeLibrary"
			get_tree().root.call_deferred("add_child", _node_library)
			_template.node_library = _node_library
		
		_template.connect("simulation_outdated", self, "generate")
		_template.connect("simulation_completed", self, "_on_simulation_completed")

	_template.load_from_file(template_path)
	_template.update_exposed_variables()

	if generate:
		generate()


func generate(force_full_simulation := false) -> void:
	# 模拟整个过程
	if not Engine.is_editor_hint():
		return

	_template.generate(force_full_simulation) # Actual simulation happens here


func set_template_path(val) -> void:
	if template_path != val:
		template_path = val
		if get_parent() and get_tree():
			reload_template()
			emit_signal("template_path_changed", val)	# This signal is only useful for the editor view
	
func _on_input_changed(node) -> void:
	generate(true)


func _on_simulation_completed() -> void:
	pass


