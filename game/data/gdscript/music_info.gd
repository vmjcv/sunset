# Tool generated file DO NOT MODIFY
tool

class music_infoData:
	var name: String
	var path: String
	func _init(p_name, p_path):
		name = p_name
		path = p_path

static func load_configs():
	return [
		music_infoData.new("菜单", "res://music/C0-0.ogg"),
		music_infoData.new("1-1", "res://music/C1-1.ogg"),
		music_infoData.new("1-2", "res://music/C1-2.ogg"),
		music_infoData.new("1-3", "res://music/C1-2.ogg"),
		music_infoData.new("1-4", "res://music/C1-2.ogg"),
		music_infoData.new("1-5", "res://music/C1-3.ogg"),
		music_infoData.new("2-1", "res://music/C2-1.ogg"),
		music_infoData.new("2-2", "res://music/C2-2.ogg"),
		music_infoData.new("3-1", "res://music/C3-2.ogg"),
	]
