extends TextureRect

var startTime = 0
const allTime = 3
var talker
var value
var nameStr
signal finish_talk


var talk_list=[]

func one_fade_in():
	# 一段话淡入结束	
	pass

func one_fade_out():
	# 一段话淡出结束
	if talk_list.size()>0:
		talk_next()
	else:
		get_node("AnimationPlayer").play("down")
	

func _ready():
	get_node("NinePatchRect/RichTextLabel").connect("fade_in_finished",self,"one_fade_in")
	get_node("NinePatchRect/RichTextLabel").connect("fade_out_finished",self,"one_fade_out")


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			match get_node("NinePatchRect/RichTextLabel").get_now_animation():
				"fade_in":
					# 淡入过程中点击，快进淡入过程
					get_node("NinePatchRect/RichTextLabel").stop()
					one_fade_in()
					pass
				"fade_out":
					# 淡出过程中点击，快进淡出过程
					get_node("NinePatchRect/RichTextLabel").stop()
					one_fade_out()
					pass
					
				"":
					# 没有动画的时候点击，是已经淡入后的状态
					if talk_list.size()>0:
						get_node("NinePatchRect/RichTextLabel").fade_out()
					else:
						get_node("AnimationPlayer").play("down")
			


func close_panel():
	queue_free()
	emit_signal("finish_talk")


func add_talk(talk_player,talk_string):
	talk_list.append([talk_player,talk_string])

func add_talk_list(temp_talk_list):
	for onetalk in temp_talk_list:
		talk_list.append(onetalk)

func talk_begin():
	get_node("AnimationPlayer").play("up")
	
func show_talker(name_id):
	if name_id==0:
		$mom.hide()
		$daughter.show()
	elif name_id==1:
		$daughter.hide()
		$mom.show()
		
func talk_next():
	var one_talk = talk_list.pop_front()
	if one_talk:
		get_node("NinePatchRect/RichTextLabel").time=0
		var name_id = one_talk[0]
		var value = one_talk[1]
		show_talker(name_id)
		var name_str
		if name_id == 0:
			name_str="我"
		elif name_id == 1:
			name_str = "妈妈"
		get_node("NinePatchRect/RichTextLabel").bbcode_text = "[color=gray]"+name_str+":[/color] [bounce id=talk]"+value+"[/bounce]"
		get_node("NinePatchRect/RichTextLabel").fade_in()
