extends Container

var result_item = preload("res://scene/result/result_item.tscn")
var result_line = preload("res://scene/result/result_line.tscn")
onready var open_box = $"box_open"
onready var close_box = $"box_close"
onready var label_container = $"label_container"

var _item_name_list

var item_count

func _ready():
	get_item_list({"结婚照":{"item_name":"花束"},"结婚照1":{"item_name":"花束"},"结婚照2":{"item_name":"花束"},"结婚照3":{"item_name":"花束"},"结婚照4":{"item_name":"花束"}})
	pass 



func get_item_list(item_name_dict):
	_item_name_list = []
	item_count = 0 
	for key in item_name_dict.values():
		_item_name_list.append(key.item_name)
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

	pass
	#PlotMgr.getResult(_item_name_list)
