# Tool generated file DO NOT MODIFY
tool

class plot_infoData:
	var after: Array
	var after_cg: int
	var ant: int
	var award: int
	var before: Array
	var big_ant: int
	var daughter: int
	var description: String
	var flower: int
	var ground_fissure: int
	var mom: int
	var picture: int
	var ring: int
	var state: int
	var to_level: String
	func _init(p_after, p_after_cg, p_ant, p_award, p_before, p_big_ant, p_daughter, p_description, p_flower, p_ground_fissure, p_mom, p_picture, p_ring, p_state, p_to_level):
		after = p_after
		after_cg = p_after_cg
		ant = p_ant
		award = p_award
		before = p_before
		big_ant = p_big_ant
		daughter = p_daughter
		description = p_description
		flower = p_flower
		ground_fissure = p_ground_fissure
		mom = p_mom
		picture = p_picture
		ring = p_ring
		state = p_state
		to_level = p_to_level

static func load_configs():
	return [
		plot_infoData.new(JSON.parse("[]").result, 0, 1, 3, JSON.parse("[[0,\"妈妈为什么一个人坐在这里......\"],[0,\"我能做些什么让她开心起来吗......\"]]").result, 2, 1, "进入第一幕", 3, 2, 2, 2, 2, 1, "0-0"),
		plot_infoData.new(JSON.parse("[]").result, 0, 0, 0, JSON.parse("[[0,\"妈妈最喜欢花了，如果给家里布置点花她一定会开心的！\"]]").result, 0, 0, "第一幕点击花瓶", 0, 0, 0, 0, 0, 2, "1-1"),
		plot_infoData.new(JSON.parse("[]").result, 0, 0, 0, JSON.parse("[[0,\"妈妈看到我的好成绩，一定会高兴的吧！\"]]").result, 0, 0, "第一幕点击抽屉", 0, 0, 0, 0, 0, 3, "1-2"),
		plot_infoData.new(JSON.parse("[]").result, 0, 0, 0, JSON.parse("[[0,\"妈妈！看这个花漂亮吧~\"],[1,\"... ... 啊... 是囡囡啊...\"],[0,\"... ... 妈...\"]]").result, 0, 0, "第一幕花瓶关卡结束", 4, 0, 0, 0, 0, 4, "0-0"),
		plot_infoData.new(JSON.parse("[]").result, 0, 0, 4, JSON.parse("[[0,\"妈妈！你快看，我有这么多奖状和证书耶！\"],[1,\"... ...\"],[1,\"... 噢...囡囡真是令妈妈骄傲...\"],[0,\"......\"]]").result, 0, 0, "第一幕抽屉关卡结束", 0, 0, 0, 0, 0, 5, "0-0"),
		plot_infoData.new(JSON.parse("[]").result, 0, 0, 0, JSON.parse("[[0,\"让妈妈想起以前快乐的日子，他们就不会离婚了吧\"]]").result, 0, 0, "第一幕点击相框", 0, 0, 0, 0, 0, 6, "1-3"),
		plot_infoData.new(JSON.parse("[]").result, 0, 0, 0, JSON.parse("[[0,\"这个一定会让妈妈想起当初的热情、誓言\"]]").result, 0, 0, "第一幕点击戒指盒", 0, 0, 0, 0, 0, 7, "1-4"),
		plot_infoData.new(JSON.parse("[]").result, 0, 0, 0, JSON.parse("[[0,\"妈妈！你看我找到了什么！你们结婚时看起来还蛮青春靓丽的哦！\"],[]]").result, 0, 0, "第一幕相框关卡结束", 0, 0, 0, 4, 0, 8, "0-0"),
		plot_infoData.new(JSON.parse("[]").result, 0, 0, 0, JSON.parse("[[0,\"妈妈！你看我找到了什么！这个钻戒闪闪发光哦！\"],[]]").result, 0, 0, "第一幕戒指关卡结束", 0, 0, 0, 0, 4, 9, "0-0"),
		plot_infoData.new(JSON.parse("[]").result, 2, 0, 0, JSON.parse("[]").result, 0, 0, "第一幕相框和戒指关卡结束", 0, 0, 0, 0, 4, 10, "0-0"),
		plot_infoData.new(JSON.parse("[]").result, 0, 2, 0, JSON.parse("[[1,\"......\"],[0,\"妈妈！你看看我呀！！\"]]").result, 0, 0, "第一幕蚂蚁爬到妈妈身上", 0, 0, 0, 0, 0, 11, "0-0"),
		plot_infoData.new(JSON.parse("[]").result, 0, 0, 0, JSON.parse("[[0,\"突然决定要分开也不和我商量... 跟你说话你也不听...  \"]]").result, 0, 0, "第一幕点击蚂蚁", 0, 0, 0, 0, 0, 12, "1-5"),
		plot_infoData.new(JSON.parse("[]").result, 3, 3, 0, JSON.parse("[]").result, 0, 0, "第一幕蚂蚁关卡结束", 0, 0, 0, 0, 0, 13, "0-0"),
	]
