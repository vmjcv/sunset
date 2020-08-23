extends Node

var level_array
var level_dict

func _ready():
	level_array = _get_table()
	level_dict = _array_to_dict(level_array)

func _get_table():
	return Configs.get_table_configs(Configs.level_infoData)

func _array_to_dict(level_array):
	var dict={}
	for obj in level_array:
		var name_str="%s_%s"%[obj.zhoumu,obj.checkpoint]
		if not dict.has(name_str):
			dict[name_str]={}
		dict[name_str][obj.priority] = obj
	return dict


func get_result(item_list):
	var level = GlobalStatusMgr.getCurLevel()
	var zhoumu = GlobalStatusMgr.getCurZhoumu()
	
	var name_str="%s_%s"%[zhoumu,level]
	
	var conditions =  level_dict[name_str] 
	for condition in conditions:
		var found= true
		for item in  condition.conditions:
			if not item in item_list:
				found=false
				break 
		if found:
			return condition.dialogue
	return false

