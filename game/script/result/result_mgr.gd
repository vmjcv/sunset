extends Node

var result_array
var result_dict

func _ready():
	result_array = _get_table()
	result_dict = _array_to_dict(result_array)

func _get_table():
	return Configs.get_table_configs(Configs.result_infoData)

func _array_to_dict(result_array):
	var dict={}
	for obj in result_array:
		var level=obj.level
		if not dict.has(level):
			dict[level]={}
		dict[level][obj.priority] = obj
	return dict


func get_result(item_list,level):
	var conditions =  result_dict[level] 
	for condition in conditions.values():
		var found= true
		for item in  condition.conditions:
			if not item in item_list:
				found=false
				break 
		if found:
			return condition
	return false
