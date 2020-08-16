extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var temp_scene = preload("res://scene/common/over_item.tscn")
onready var temp_timer = $Timer

onready var open_box = $"箱子开"
onready var close_box = $"箱子关"
onready var specialWay = false

var need_close=true
var bsc_bool = true
var _item_name_list
# Called when the node enters the scene tree for the first time.
func _ready():
	temp_timer.connect("timeout",self,"get_one")
	
	#get_item_list(["干燥剂","结婚照"])
	
	pass # Replace with function body.

func get_item_list(item_name_list,bsc):
	bsc_bool = bsc
	_item_name_list = []
	for key  in item_name_list.values():
		_item_name_list.append(key.item_name)
	get_one()
	
func get_one():
	var item_name = _item_name_list.pop_front()
	if item_name:
		need_close=false
		var now_scene = temp_scene.instance()
		add_child(now_scene)
		now_scene.change_img(item_name)
		now_scene.play_animation()
		temp_timer.start(0.3)
	else:
		if need_close:
			open_box.hide()
			move_child(close_box,get_child_count())
			close_box.show()
			
			if GlobalStatusMgr.zhoumu == 3 and  GlobalStatusMgr.curLevel == 1:
				if specialWay==true:
					SceneMgr.changeScene("res://scene/cg/VideoCg5.tscn")
					pass
				else:
					SceneMgr.changeScene("res://scene/cg/VideoCg6.tscn")
					pass
				return 
			GlobalStatusMgr._matchResult(_item_name_list,bsc_bool)
		else:
			need_close = true
			temp_timer.start(0.5)
			
func set_special_way(isSpecial):
	specialWay = isSpecial


