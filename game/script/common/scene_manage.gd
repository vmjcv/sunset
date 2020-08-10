extends Node
signal change_scene
# 场景管理类
var all:SceneTable # 所有场景
var now:SceneData # 当前场景
var item_panel = ItemMainPanel
var scene_change = SceneChange

func _init():
	_load_object(PlayerArchive.get_scene_manage())
	
func _ready():
	# change_now_scene(get(1))
	call_deferred("change_now_scene",get(1))
	pass
	

	
func _reset_HUD_scene():
	call_deferred("_move_HUD_scene")

func _move_HUD_scene():
	_HUD_remove_from_panrent()
	now.add_child(item_panel)
	now.move_child(item_panel,0)
	now.add_child(scene_change)
	now.move_child(scene_change,1)
	
func _HUD_remove_from_panrent():
	item_panel.get_parent().remove_child(item_panel)
	scene_change.get_parent().remove_child(scene_change)
	
func get(number):
	return all.get(number)

func save_object():
	var save_dict = {
		"all" : all.get_all().keys()
	}
	return save_dict

func _load_object(load_dict):
	if load_dict == null:
		load_dict = {}
	var all_table = load_dict.get("all",Array(range(1,SceneConstant.MAX_NUMBER+1)))
	all=SceneTable.new(null)
	for number in all_table:
		var scene = load("res://scene/Bg/Scene%s.tscn"%number).instance()
		scene.update_info(number)
		all.append(scene)

func change_now_scene(scene_number):
	var scene = all.get(scene_number)
	if now:
		now.get_parent().remove_child(now)
	now = scene
	get_tree().get_root().add_child(now)
	_reset_HUD_scene()
	emit_signal("change_scene",now.left,now.right,now.up,now.down)

func change_left_scene():
	if now.left>0:
		change_now_scene(now.left)
	pass

func change_right_scene():
	if now.right>0:
		change_now_scene(now.right)
	pass
	
func change_up_scene():
	if now.up>0:
		change_now_scene(now.up)
	pass
	
func change_down_scene():
	if now.down>0:
		change_now_scene(now.down)
	pass
