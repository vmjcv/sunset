# Tool generated file DO NOT MODIFY
tool

class policy_infoData:
	var UI_path: String
	var all_progress: int
	var base_bonus: Array
	var description: String
	var event_bonus: Array
	var gain_event: Array
	var number: int
	var special_bonus: Array
	var tendency: int
	var title: String
	var tree_id: int
	func _init(p_UI_path, p_all_progress, p_base_bonus, p_description, p_event_bonus, p_gain_event, p_number, p_special_bonus, p_tendency, p_title, p_tree_id):
		UI_path = p_UI_path
		all_progress = p_all_progress
		base_bonus = p_base_bonus
		description = p_description
		event_bonus = p_event_bonus
		gain_event = p_gain_event
		number = p_number
		special_bonus = p_special_bonus
		tendency = p_tendency
		title = p_title
		tree_id = p_tree_id

static func load_configs():
	return [
		policy_infoData.new("res://images/icon/policy/Policy_00001.png", 5, JSON.parse("[[1,0.05,4]]").result, "政策1:单一物种", JSON.parse("[3,4,5]").result, JSON.parse("[2,4]").result, 1, JSON.parse("[5]").result, 0, "随遇而安", 1),
		policy_infoData.new("res://images/icon/policy/Policy_00002.png", 5, JSON.parse("[[1,0.05,5]]").result, "政策2：多元物种", JSON.parse("[3,4,6]").result, JSON.parse("[2,5]").result, 2, JSON.parse("[6]").result, 1, "集权主义", 1),
		policy_infoData.new("res://images/icon/policy/Policy_00003.png", 5, JSON.parse("[[1,0.05,6]]").result, "政策3：队伍人员单一", JSON.parse("[3,4,7]").result, JSON.parse("[2,6]").result, 3, JSON.parse("[7]").result, 2, "各司其责", 1),
		policy_infoData.new("res://images/icon/policy/Policy_00004.png", 5, JSON.parse("[[1,0.05,7]]").result, "政策4：随机分配", JSON.parse("[3,4,8]").result, JSON.parse("[2,7]").result, 4, JSON.parse("[8]").result, 3, "社会达尔文", 1),
		policy_infoData.new("res://images/icon/policy/Policy_00005.png", 5, JSON.parse("[[1,0.05,8]]").result, "政策5：按价竞拍", JSON.parse("[3,4,9]").result, JSON.parse("[2,8]").result, 5, JSON.parse("[9]").result, 0, "随缘分配", 2),
		policy_infoData.new("res://images/icon/policy/Policy_00006.png", 5, JSON.parse("[[1,0.05,9]]").result, "政策6：主动派遣", JSON.parse("[3,4,10]").result, JSON.parse("[2,9]").result, 6, JSON.parse("[10]").result, 1, "人工派遣", 2),
		policy_infoData.new("res://images/icon/policy/Policy_00007.png", 5, JSON.parse("[[1,0.05,10]]").result, "政策7：随机抽取", JSON.parse("[3,4,11]").result, JSON.parse("[2,10]").result, 7, JSON.parse("[11]").result, 2, "按职分配", 2),
		policy_infoData.new("res://images/icon/policy/Policy_00008.png", 5, JSON.parse("[[1,0.05,11]]").result, "政策8", JSON.parse("[3,4,12]").result, JSON.parse("[2,11]").result, 8, JSON.parse("[12]").result, 3, "待价而沽", 2),
		policy_infoData.new("res://images/icon/policy/Policy_00009.png", 5, JSON.parse("[[1,0.05,12]]").result, "政策9", JSON.parse("[3,4,13]").result, JSON.parse("[2,12]").result, 9, JSON.parse("[13]").result, 0, "随机抽取", 3),
		policy_infoData.new("res://images/icon/policy/Policy_00010.png", 5, JSON.parse("[[1,0.05,13]]").result, "政策10", JSON.parse("[3,4,14]").result, JSON.parse("[2,13]").result, 10, JSON.parse("[14]").result, 1, "推举制度", 3),
		policy_infoData.new("res://images/icon/policy/Policy_00011.png", 5, JSON.parse("[[1,0.05,14]]").result, "政策11", JSON.parse("[3,4,15]").result, JSON.parse("[2,14]").result, 11, JSON.parse("[15]").result, 2, "定向抽取", 3),
		policy_infoData.new("res://images/icon/policy/Policy_00012.png", 5, JSON.parse("[[1,0.05,15]]").result, "政策12", JSON.parse("[3,4,16]").result, JSON.parse("[2,15]").result, 12, JSON.parse("[16]").result, 3, "夺魁战争", 3),
		policy_infoData.new("res://images/icon/policy/Policy_00013.png", 5, JSON.parse("[[1,0.05,16]]").result, "政策13", JSON.parse("[3,4,17]").result, JSON.parse("[2,16]").result, 13, JSON.parse("[17]").result, 0, "不做干涉", 4),
		policy_infoData.new("res://images/icon/policy/Policy_00014.png", 5, JSON.parse("[[1,0.05,17]]").result, "政策14", JSON.parse("[3,4,18]").result, JSON.parse("[2,17]").result, 14, JSON.parse("[18]").result, 1, "权限判断", 4),
		policy_infoData.new("res://images/icon/policy/Policy_00015.png", 5, JSON.parse("[[1,0.05,18]]").result, "政策15", JSON.parse("[3,4,19]").result, JSON.parse("[2,18]").result, 15, JSON.parse("[19]").result, 2, "不可泄漏", 4),
		policy_infoData.new("res://images/icon/policy/Policy_00016.png", 5, JSON.parse("[[1,0.05,19]]").result, "政策16", JSON.parse("[3,4,20]").result, JSON.parse("[2,19]").result, 16, JSON.parse("[20]").result, 3, "条例惩罚", 4),
		policy_infoData.new("res://images/icon/policy/Policy_00017.png", 5, JSON.parse("[[1,0.05,20]]").result, "政策17", JSON.parse("[3,4,21]").result, JSON.parse("[2,20]").result, 17, JSON.parse("[21]").result, 0, "菩提院", 5),
		policy_infoData.new("res://images/icon/policy/Policy_00018.png", 5, JSON.parse("[[1,0.05,21]]").result, "政策18", JSON.parse("[3,4,22]").result, JSON.parse("[2,21]").result, 18, JSON.parse("[22]").result, 1, "研修所", 5),
		policy_infoData.new("res://images/icon/policy/Policy_00019.png", 5, JSON.parse("[[1,0.05,22]]").result, "政策19", JSON.parse("[3,4,23]").result, JSON.parse("[2,22]").result, 19, JSON.parse("[23]").result, 2, "冒险公会", 5),
		policy_infoData.new("res://images/icon/policy/Policy_00020.png", 5, JSON.parse("[[1,0.05,23]]").result, "政策20", JSON.parse("[3,4,24]").result, JSON.parse("[2,23]").result, 20, JSON.parse("[24]").result, 3, "开拓所", 5),
		policy_infoData.new("res://images/icon/policy/Policy_00021.png", 5, JSON.parse("[[1,0.05,24]]").result, "政策21", JSON.parse("[3,4,25]").result, JSON.parse("[2,24]").result, 21, JSON.parse("[25]").result, 0, "不做干涉", 6),
		policy_infoData.new("res://images/icon/policy/Policy_00022.png", 5, JSON.parse("[[1,0.05,25]]").result, "政策22", JSON.parse("[3,4,26]").result, JSON.parse("[2,25]").result, 22, JSON.parse("[26]").result, 1, "统一管理", 6),
		policy_infoData.new("res://images/icon/policy/Policy_00023.png", 5, JSON.parse("[[1,0.05,26]]").result, "政策23", JSON.parse("[3,4,27]").result, JSON.parse("[2,26]").result, 23, JSON.parse("[27]").result, 2, "分级管理", 6),
		policy_infoData.new("res://images/icon/policy/Policy_00024.png", 5, JSON.parse("[[1,0.05,27]]").result, "政策24", JSON.parse("[3,4,28]").result, JSON.parse("[2,27]").result, 24, JSON.parse("[28]").result, 3, "强势反击", 6),
		policy_infoData.new("res://images/icon/policy/Policy_00025.png", 5, JSON.parse("[[1,0.05,28]]").result, "政策25", JSON.parse("[3,4,29]").result, JSON.parse("[2,28]").result, 25, JSON.parse("[29]").result, 0, "随缘入侵", 7),
		policy_infoData.new("res://images/icon/policy/Policy_00026.png", 5, JSON.parse("[[1,0.05,29]]").result, "政策26", JSON.parse("[3,4,30]").result, JSON.parse("[2,29]").result, 26, JSON.parse("[30]").result, 1, "潜入入侵", 7),
		policy_infoData.new("res://images/icon/policy/Policy_00027.png", 5, JSON.parse("[[1,0.05,30]]").result, "政策27", JSON.parse("[3,4,31]").result, JSON.parse("[2,30]").result, 27, JSON.parse("[31]").result, 2, "契约入侵", 7),
		policy_infoData.new("res://images/icon/policy/Policy_00028.png", 5, JSON.parse("[[1,0.05,31]]").result, "政策28", JSON.parse("[3,4,32]").result, JSON.parse("[2,31]").result, 28, JSON.parse("[32]").result, 3, "主动入侵", 7),
		policy_infoData.new("res://images/icon/policy/Policy_00029.png", 5, JSON.parse("[[1,0.05,32]]").result, "政策29", JSON.parse("[3,4,33]").result, JSON.parse("[2,32]").result, 29, JSON.parse("[33]").result, 0, "随机发展", 8),
		policy_infoData.new("res://images/icon/policy/Policy_00030.png", 5, JSON.parse("[[1,0.05,33]]").result, "政策30", JSON.parse("[3,4,34]").result, JSON.parse("[2,33]").result, 30, JSON.parse("[34]").result, 1, "科技优先", 8),
		policy_infoData.new("res://images/icon/policy/Policy_00031.png", 5, JSON.parse("[[1,0.05,34]]").result, "政策31", JSON.parse("[3,4,35]").result, JSON.parse("[2,34]").result, 31, JSON.parse("[35]").result, 2, "政策变换", 8),
		policy_infoData.new("res://images/icon/policy/Policy_00032.png", 5, JSON.parse("[[1,0.05,35]]").result, "政策32", JSON.parse("[3,4,36]").result, JSON.parse("[2,35]").result, 32, JSON.parse("[36]").result, 3, "人员培养", 8),
		policy_infoData.new("res://images/icon/policy/Policy_00033.png", 5, JSON.parse("[[1,0.05,36]]").result, "政策33", JSON.parse("[3,4,37]").result, JSON.parse("[2,36]").result, 33, JSON.parse("[37]").result, 0, "无为而治", 9),
		policy_infoData.new("res://images/icon/policy/Policy_00034.png", 5, JSON.parse("[[1,0.05,37]]").result, "政策34", JSON.parse("[3,4,38]").result, JSON.parse("[2,37]").result, 34, JSON.parse("[38]").result, 1, "科技蜕变", 9),
		policy_infoData.new("res://images/icon/policy/Policy_00035.png", 5, JSON.parse("[[1,0.05,38]]").result, "政策35", JSON.parse("[3,4,39]").result, JSON.parse("[2,38]").result, 35, JSON.parse("[39]").result, 2, "层层管理", 9),
		policy_infoData.new("res://images/icon/policy/Policy_00036.png", 5, JSON.parse("[[1,0.05,39]]").result, "政策36", JSON.parse("[3,4,40]").result, JSON.parse("[2,39]").result, 36, JSON.parse("[40]").result, 3, "战争激励", 9),
	]
