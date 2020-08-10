# 玩家存档类
extends Node
var item:Dictionary # 道具信息
var item_manage # 道具管理器
var scene_manage # 场景管理器

func _init():
	item = {}
	item_manage = null
	scene_manage = null

func save_item(number):
	var save_game = File.new()
	save_game.open("user://savegame/item%s.save"%number, File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Item")
	for node in save_nodes:
		if node.filename.empty():
			continue

		if !node.has_method("save_object"):
			continue

		var node_data = node.call("save_object")
		save_game.store_line(to_json(node_data))
	save_game.close()

func save_item_manage(number):
	var save_game = File.new()
	save_game.open("user://savegame/item_manage%s.save"%number, File.WRITE)
	var node = get_tree().get_node("ItemManage")

	if node.filename.empty():
		save_game.close()
		return 

	if !node.has_method("save_object"):
		save_game.close()
		return 

	var node_data = node.call("save_object")
	save_game.store_line(to_json(node_data))
	save_game.close()
	
func save_scene_manage(number):
	var save_game = File.new()
	save_game.open("user://savegame/scene_manage%s.save"%number, File.WRITE)
	var node = get_tree().get_node("SceneManage")

	if node.filename.empty():
		save_game.close()
		return 

	if !node.has_method("save_object"):
		save_game.close()
		return 

	var node_data = node.call("save_object")
	save_game.store_line(to_json(node_data))
	save_game.close()

func save_game(number):
	save_item(number)
	save_item_manage(number)
	save_scene_manage(number)
	
func load_item(number):
	item.clear()
	var save_game = File.new()
	if not save_game.file_exists("user://savegame/item%s.save"%number):
		return 
	save_game.open("user://savegame/item%s.save"%number, File.READ)
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		item[node_data.number]=node_data
	save_game.close()
	
func load_item_manage(number):
	item_manage = null
	var save_game = File.new()
	if not save_game.file_exists("user://savegame/item_manage%s.save"%number):
		return 
	save_game.open("user://savegame/item_manage%s.save"%number, File.READ)
	var node_data = parse_json(save_game.get_line())
	item_manage = node_data
	save_game.close()
	
func load_scene_manage(number):
	item_manage = null
	var save_game = File.new()
	if not save_game.file_exists("user://savegame/scene_manage%s.save"%number):
		return 
	save_game.open("user://savegame/scene_manage%s.save"%number, File.READ)
	var node_data = parse_json(save_game.get_line())
	item_manage = node_data
	save_game.close()

func load_game(number):
	load_item(number)
	load_item_manage(number)
	load_scene_manage(number)

func get_item(item_number):
	return item.get(item_number)
	
func get_item_manage():
	return item_manage

func get_scene_manage():
	return scene_manage

