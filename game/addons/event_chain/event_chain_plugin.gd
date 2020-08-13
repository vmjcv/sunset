tool
extends EditorPlugin

# 事件链插件是基于节点的内容创建工具。
# 该插件提供了一个基础框架：状态信息，触发事件，回调事件，
# 需注意游戏中可能同时存在多个事件链条，所以事件编号要是全局唯一的量

var _graph_editor_view
var _panel_button: Button
var _editor_selection: EditorSelection
var _event_chain_graph: EventChainGraph
var _node_library: EventChainNodeLibrary
var _editor_gizmo_plugins: Array
var _proxy


func _enter_tree() -> void:
	#add_autoload_singleton("EventChainGraphManage","res://addons/event_chain/src/core/graph_manage.gd")
	#add_autoload_singleton("EventChainSignalManage","res://addons/event_chain/src/core/signal_manage.gd")
	_add_custom_editor_view()
	_connect_editor_signals()
	_setup_node_library()
	_setup_editor_plugin_proxy()
	EventChainGraphSettings.initialize()


func _exit_tree() -> void:
	_disconnect_editor_signals()
	_remove_custom_editor_view()
	_remove_node_library()
	_remove_editor_plugin_proxy()


func _add_custom_editor_view() -> void:
	_graph_editor_view = preload("editor/src/editor/gui/editor_view.tscn").instance()
	_graph_editor_view.undo_redo = get_undo_redo()
	_panel_button = add_control_to_bottom_panel(_graph_editor_view, "Event Chain Graph Editor")
	_panel_button.visible = true


func _remove_custom_editor_view() -> void:
	if _graph_editor_view:
		remove_control_from_bottom_panel(_graph_editor_view)
		_graph_editor_view.queue_free()


func _connect_editor_signals() -> void:
	_editor_selection = get_editor_interface().get_selection()
	_editor_selection.connect("selection_changed", self, "_on_selection_changed")
	connect("scene_changed", self, "_on_scene_changed")
	connect("scene_closed", self, "_on_scene_changed")
	_on_selection_changed()


func _disconnect_editor_signals() -> void:
	disconnect("scene_changed", self, "_on_scene_changed")
	disconnect("scene_closed", self, "_on_scene_changed")
	if _editor_selection:
		_editor_selection.disconnect("selection_changed", self, "_on_selection_changed")


func _setup_node_library() -> void:
	if _node_library:
		_node_library.refresh_list()
		return
	_node_library = EventChainNodeLibrary.new()
	_node_library.name = "EventChainNodeLibrary"
	
	get_tree().root.call_deferred("add_child", _node_library)


func _remove_node_library() -> void:
	# return # TMP during development
	if _node_library:
		get_tree().root.remove_child(_node_library)
		_node_library.queue_free()
		_node_library = null


func _setup_editor_plugin_proxy() -> void:
	if _proxy:
		return
	_proxy = preload("editor/src/common/editor_plugin_proxy.gd").new()
	_proxy.name = "EventChainGraphEditorPluginProxy"
	_proxy.proxy = self
	get_tree().root.call_deferred("add_child", _proxy)


func _remove_editor_plugin_proxy() -> void:
	if _proxy:
		get_tree().root.remove_child(_proxy)
		_proxy.queue_free()
		_proxy = null




func _on_selection_changed() -> void:
	# @:如果选择了新的EventChainGraph，请通知editor_view。 如果是另一种节点，则什么也不做，并保持编辑器处于打开状态。
	_editor_selection = get_editor_interface().get_selection()
	var selected_nodes = _editor_selection.get_selected_nodes()

	for node in selected_nodes:
		if node is EventChainGraph:
			_event_chain_graph = node
			_graph_editor_view.enable_template_editor_for(_event_chain_graph)
			return


func _on_scene_changed(_param) -> void:
	_graph_editor_view.clear_template_editor()
	_on_selection_changed()
