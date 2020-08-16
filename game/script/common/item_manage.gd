extends Node
signal get_item
var item_array
var item_dict
var item_list = []

func _ready():
	item_array = _get_table()
	item_dict = _array_to_dict(item_array)
	connect("get_item",self,"_get_item")

func _get_table():
	return Configs.get_table_configs(Configs.item_infoData)

func _array_to_dict(item_array):
	var dict={}
	for obj in item_array:
		dict[obj.name]=obj
		if obj.id!=-1:
			dict[obj.id]=obj
	return dict

func get_by_name(item_name):
	var level = GlobalStatusMgr.getCurLevel()
	var zhoumu = GlobalStatusMgr.getCurZhoumu()
	var new_item_name =item_name+"_"+String(level)+"_"+String(zhoumu)
	if item_dict.has(new_item_name):
		return item_dict[new_item_name]
	else:
		if item_dict.has(item_name):
			return item_dict[item_name]
		else:
			return ""

func show_item_talk(id):
	var current_item = get_by_name(item_dict[id].name)
	var info = _create_info(current_item)
	print(id)
	print(item_dict[id].name)
	#text_manage(0,info)
	TalkMgr.talk([[0,info]])
	
	
	item_list.append(info)
	TalkMgr.talk([[0, info]])
	return 

func _create_info(current_item):
	var new_item_name = current_item.name.split("_")[0]
	match current_item.name:
		"钢笔":
			return current_item.info 
		"钢笔_1_1":
			if _have_item("纸_1_1"):
				return get_by_name("规章")
	return current_item.info 

func _have_item(_item_name):
	for item in item_list:
		if item.name == _item_name:
			return true
	return false



