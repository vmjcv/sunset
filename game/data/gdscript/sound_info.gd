# Tool generated file DO NOT MODIFY
tool

class sound_infoData:
	var name: String
	var path: String
	func _init(p_name, p_path):
		name = p_name
		path = p_path

static func load_configs():
	return [
		sound_infoData.new("蚂蚁坠落", "res://sound/ant_fall.ogg"),
		sound_infoData.new("蚂蚁移动", "res://sound/ant_move.ogg"),
		sound_infoData.new("蚂蚁长移动", "res://sound/ant_walk_long.ogg"),
		sound_infoData.new("蚂蚁短移动", "res://sound/ant_walk_short.ogg"),
		sound_infoData.new("转场动画1", "res://sound/end_transition_1.ogg"),
		sound_infoData.new("转场动画2", "res://sound/end_transition_2.ogg"),
		sound_infoData.new("地板扣血", "res://sound/floor_deduction.ogg"),
		sound_infoData.new("得到道具", "res://sound/item_get.ogg"),
		sound_infoData.new("主菜单点击", "res://sound/menu_click.ogg"),
		sound_infoData.new("重置关卡", "res://sound/restart.ogg"),
		sound_infoData.new("尖刺陷阱", "res://sound/spike_trap.ogg"),
		sound_infoData.new("转场间隙", "res://sound/stage_clear.ogg"),
		sound_infoData.new("粘性触发", "res://sound/sticky_trigger.ogg"),
		sound_infoData.new("成功过关", "res://sound/success.ogg"),
	]
