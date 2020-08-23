# Tool generated file DO NOT MODIFY
tool

class level_infoData:
	var checkpoint: int
	var conditions: Array
	var dialogue: String
	var priority: int
	var zhoumu: int
	func _init(p_checkpoint, p_conditions, p_dialogue, p_priority, p_zhoumu):
		checkpoint = p_checkpoint
		conditions = p_conditions
		dialogue = p_dialogue
		priority = p_priority
		zhoumu = p_zhoumu

static func load_configs():
	return [
		level_infoData.new(1, JSON.parse("[\"奖状\",\"笔\",\"纸\",\"录取通知书\"]").result, "一周目一关卡结尾对话", 1, 1),
		level_infoData.new(2, JSON.parse("[\"红花\",\"蓝花\",\"黄花\"]").result, "一周目二关卡结尾对话", 1, 1),
		level_infoData.new(3, JSON.parse("[\"花照片\",\"结婚照\"]").result, "一周目三关卡结尾对话", 1, 1),
		level_infoData.new(4, JSON.parse("[\"钻戒\",\"草戒指\"]").result, "一周目四关卡结尾对话", 1, 1),
		level_infoData.new(5, JSON.parse("[\"负面情绪\",\"负面情绪\",\"负面情绪\",\"负面情绪\"]").result, "一周目五关卡结尾对话", 1, 1),
		level_infoData.new(1, JSON.parse("[\"干燥剂\",\"红花\",\"蓝花\",\"黄花\"]").result, "二周目一关卡结尾对话", 1, 2),
		level_infoData.new(2, JSON.parse("[\"结婚照\"]").result, "二周目二关卡结尾对话", 1, 2),
		level_infoData.new(1, JSON.parse("[\"奇怪的门\"]").result, "三周目一关卡结尾对话", 1, 3),
	]
