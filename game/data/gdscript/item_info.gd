# Tool generated file DO NOT MODIFY
tool

class item_infoData:
	var id: int
	var info: String
	var name: String
	func _init(p_id, p_info, p_name):
		id = p_id
		info = p_info
		name = p_name

static func load_configs():
	return [
		item_infoData.new(1, "这是妈妈给我的钢笔哟", "钢笔"),
		item_infoData.new(1, "这是一周目第二关卡妈妈送给我的礼物哦", "钢笔_1_2"),
	]
