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

	


func fade_finish(state_obj,obj):
	obj.disconnect("fade_finish",self,"fade_finish")
	finish_count = finish_count - 1
	if finish_count == 0:
		after_change(state_obj)

func after_change(state_obj):
	TalkMgr.connect("finish_talk",self,"state_change_over")
	TalkMgr.talk(state_obj.after)
	
	pass

func state_change_over():
	emit_signal("change_over")

