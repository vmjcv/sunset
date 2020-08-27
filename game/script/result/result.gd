extends Container

var result_item = preload("res://scene/result/result_item.tscn")
var result_line = preload("res://scene/result/result_line.tscn")
onready var open_box = $"box_open"
onready var close_box = $"box_close"
onready var label_container = $"label_container"

var _item_name_list
var _item_result
var _level 
var item_count

func _ready():
	# test
	# get_item_list({"奖状":{"item_name":"奖状"},"钢笔":{"item_name":"钢笔"},"纸":{"item_name":"纸"},"通知书":{"item_name":"通知书"}})
	pass 



func get_item_list(item_name_dict,level):
	_item_name_list = []
	_item_result = []
	item_count = 0 
	_level = level
	for key in item_name_dict.values():
		_item_name_list.append(key.item_name)
		_item_result.append(key.item_name)
		item_count = item_count + 1
	
	if item_count<=0:
		# 没有道具，直接结束动画
		get_item_done()
	else:
		get_one()
		var temp_timer = Timer.new()
		add_child(temp_timer)
		temp_timer.connect("timeout",self,"get_one",[temp_timer])
		temp_timer.start(0.4)
	
func get_one(timer=null):
	var item_name = _item_name_list.pop_front()
	if item_name:
		var item_obj = result_item.instance()
		add_child(item_obj)
		item_obj.connect("get_item",self,"get_item_done")
		item_obj.change_img(item_name)
		item_obj.play_animation()
		
		var item_line = result_line.instance()
		item_line.set_label(item_name,label_container.get_child_count())
		label_container.add_child(item_line)
		item_line.show()
	else:
		timer.stop()
			
			
func get_item_done():
	item_count = item_count - 1
	if item_count<=0:
		open_box.hide()
		move_child(close_box,get_child_count())
		close_box.show()
		var temp_timer = Timer.new()
		temp_timer.one_shot=true 
		add_child(temp_timer)
		temp_timer.connect("timeout",self,"result_done")
		temp_timer.start(0.6)
		

func result_done():
	# @:所有的结果动画结束
	var result_obj = ResultMgr.get_result(_item_result,_level)
	if result_obj:
		TalkMgr.connect("finish_talk",self,"change_state",[result_obj])
		TalkMgr.talk(result_obj.dialogue)
	

func change_state(result_obj):
	TalkMgr.disconnect("finish_talk",self,"change_state")
	var sec = 0.1
	#Fade.fade_out(self, sec, funcref(self, "remove_self"))
	PlotBG.go_state(result_obj.state)
	
	queue_free()


