extends Container

var plot_array
var plot_dict

var finish_count

signal change_over

onready var ant = $ant
onready var award = $award
onready var big_ant = $big_ant
onready var daughter = $daughter
onready var flower = $flower
onready var ground_fissure = $ground_fissure
onready var mom = $mom
onready var picture = $picture
onready var ring = $ring
var level = preload("res://scene/level/level.tscn")

var need_check_state10 =false
var need_check_state14 =false

func _ready():
	plot_array = _get_table()
	plot_dict = _array_to_dict(plot_array)


func _get_table():
	return Configs.get_table_configs(Configs.plot_infoData)

func _array_to_dict(plot_array):
	var dict={}
	for obj in plot_array:
		var name_str=obj.state
		dict[name_str]=obj
	return dict

func go_state(state):
	var state_obj = plot_dict[state]
	if state_obj.state == 8 or state_obj.state == 9:
		# 如果是戒指关卡过关或者相框关卡过关
		need_check_state10 = true
	if state_obj.state == 4 or state_obj.state == 5:
		# 如果是花瓶关卡过关或者抽屉关卡过关
		need_check_state14 = true	

	
	before_change(state_obj)


func before_change(state_obj):
	TalkMgr.connect("finish_talk",self,"change_state",[state_obj])
	TalkMgr.talk(state_obj.before)

func change_state(state_obj):
	TalkMgr.disconnect("finish_talk",self,"change_state")
	finish_count = 0
	for status_list in [[ant,state_obj.ant],[award,state_obj.award],
	[big_ant,state_obj.big_ant],[daughter,state_obj.daughter],[flower,state_obj.flower],
	[ground_fissure,state_obj.ground_fissure],[mom,state_obj.mom],
	[picture,state_obj.picture],[ring,state_obj.ring]]:
		change_one(status_list[0],state_obj,status_list[1])
		pass
	
	if finish_count == 0:
		after_change(state_obj)

func change_one(obj,state_obj,state_number):
	if state_number != 0 and state_number!=obj.now_status:
		obj.next_status = state_number
		obj.connect("fade_finish",self,"fade_finish",[state_obj])
		finish_count = finish_count + 1
		obj.change()

func fade_finish(obj,state_obj):
	obj.disconnect("fade_finish",self,"fade_finish")
	finish_count = finish_count - 1
	if finish_count == 0:
		after_change(state_obj)

func after_change(state_obj):
	TalkMgr.connect("finish_talk",self,"after_talking_over",[state_obj])
	TalkMgr.talk(state_obj.after)

func after_talking_over(state_obj):
	TalkMgr.disconnect("finish_talk",self,"after_talking_over")
	CGMgr.connect("cg_over",self,"state_change_over",[state_obj])
	

	CGMgr.show_cg(state_obj.after_cg)
	
	
	

func state_change_over(state_obj):
	CGMgr.disconnect("cg_over",self,"state_change_over")
	var temp_array = state_obj.to_level.split("-")
	var cur_zhoumu = int(temp_array[0])
	var cur_level = int(temp_array[1])
	if cur_zhoumu ==0 and cur_level ==0:
		emit_signal("change_over")
	else:
		var level_obj = level.instance()
		get_tree().get_root().add_child(level_obj)
		var panel = level_obj.get_node("Panel")
		panel.set_map_id(cur_level, cur_zhoumu)
		AudioPlayer.play_bg(state_obj.to_level)
		emit_signal("change_over")
	if need_check_state10 == true:
		need_check_state10 = false
		if check_state10():
			PlotBG.go_state(10)
	if need_check_state14 == true:
		need_check_state14 = false
		if check_state14():
			PlotBG.go_state(14)
	
func check_state10():
	if picture.is_change() and ring.is_change():
		return true
	return false

func check_state14():
	if flower.is_change() and award.is_change():
		return true
	return false
