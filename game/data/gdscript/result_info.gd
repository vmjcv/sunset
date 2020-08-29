# Tool generated file DO NOT MODIFY
tool

class result_infoData:
	var conditions: Array
	var description: String
	var dialogue: Array
	var level: String
	var priority: int
	var state: int
	func _init(p_conditions, p_description, p_dialogue, p_level, p_priority, p_state):
		conditions = p_conditions
		description = p_description
		dialogue = p_dialogue
		level = p_level
		priority = p_priority
		state = p_state

static func load_configs():
	return [
		result_infoData.new(JSON.parse("[\"红花\",\"蓝花\",\"黄花\"]").result, "一周目一关卡结尾对话", JSON.parse("[[0,\"一周目一关卡结尾对话\"]]").result, "1-1", 1, 4),
		result_infoData.new(JSON.parse("[\"奖状\",\"钢笔\",\"纸\",\"通知书\"]").result, "一周目二关卡结尾对话", JSON.parse("[[0,\"一周目二关卡结尾对话\"]]").result, "1-2", 1, 5),
		result_infoData.new(JSON.parse("[\"花照片\",\"结婚照\"]").result, "一周目三关卡结尾对话", JSON.parse("[[0,\"一周目三关卡结尾对话\"]]").result, "1-3", 1, 8),
		result_infoData.new(JSON.parse("[\"钻戒\",\"草戒指\"]").result, "一周目四关卡结尾对话", JSON.parse("[[0,\"一周目四关卡结尾对话\"]]").result, "1-4", 1, 9),
		result_infoData.new(JSON.parse("[\"负面情绪\",\"负面情绪\",\"负面情绪\",\"负面情绪\"]").result, "一周目五关卡结尾对话", JSON.parse("[[0,\"一周目五关卡结尾对话\"]]").result, "1-5", 1, 13),
		result_infoData.new(JSON.parse("[\"干燥剂\",\"红花\",\"蓝花\",\"黄花\"]").result, "二周目一关卡结尾对话", JSON.parse("[[0,\"二周目一关卡结尾对话\"]]").result, "2-1", 1, 0),
		result_infoData.new(JSON.parse("[\"结婚照\"]").result, "二周目二关卡结尾对话", JSON.parse("[[0,\"二周目二关卡结尾对话\"]]").result, "2-2", 1, 0),
		result_infoData.new(JSON.parse("[\"奇怪的门\"]").result, "三周目一关卡结尾对话", JSON.parse("[[0,\"三周目一关卡结尾对话\"]]").result, "3-1", 1, 0),
	]
