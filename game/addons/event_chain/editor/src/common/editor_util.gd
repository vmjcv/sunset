tool
class_name EventChainGraphEditorUtil
# 编辑器公用插件

# Taken from https://github.com/Zylann/godot_heightmap_plugin/blob/master/addons/zylann.hterrain/tools/util/editor_util.gd
static func get_dpi_scale() -> float:
	if not Engine.is_editor_hint():
		return 1.0
	var editor_plugin = EditorPlugin.new()
	var editor_settings = editor_plugin.get_editor_interface().get_editor_settings()
	editor_plugin.queue_free()
	var display_scale = editor_settings.get("interface/editor/display_scale")
	var custom_display_scale = editor_settings.get("interface/editor/custom_display_scale")
	var edscale := 0.0

	match display_scale:
		0:
			# Try applying a suitable display scale automatically
			var screen = OS.current_screen
			var large = OS.get_screen_dpi(screen) >= 192 and OS.get_screen_size(screen).x > 2000
			edscale = 2.0 if large else 1.0
		1:
			edscale = 0.75
		2:
			edscale = 1.0
		3:
			edscale = 1.25
		4:
			edscale = 1.5
		5:
			edscale = 1.75
		6:
			edscale = 2.0
		_:
			edscale = custom_display_scale

	return edscale


static func get_plugin_root_path() -> String:
	# @:返回res://addons/event_chain_graph文件夹
	var dummy = EventChainGraphNodePool.new()
	var path = dummy.get_script().get_path()
	dummy.queue_free()
	return path.replace("editor/src/core/node_pool.gd", "")


static func get_square_texture(color: Color) -> ImageTexture:
	# @:返回正方形纹理或给定的颜色。 用于在同一插槽上接受多个连接的GraphNode中。
	var image = Image.new()
	image.create(10, 10, false, Image.FORMAT_RGBA8)
	image.fill(color)

	var imageTexture = ImageTexture.new()
	imageTexture.create_from_image(image)
	imageTexture.resource_name = "square " + String(color.to_rgba32())

	return imageTexture
