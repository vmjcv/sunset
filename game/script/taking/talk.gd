extends TextureRect

var startTime = 0
var bStart = false
const allTime = 3
var talker
var value
signal finish_one_talk

func _ready():
	
	pass # Replace with function body.

func _process(delta):
	if not bStart:
		return
	var cal =  (OS.get_ticks_msec() - startTime) / allTime
	if cal > 1000:
		get_node("NinePatchRect/label").time = 1
		bStart = false
		return
	get_node("NinePatchRect/label").time = float(cal) / 1000
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if get_node("NinePatchRect/label").time < 1:
				get_node("NinePatchRect/label").time = 1
				bStart = false
			else:
				get_node("AnimationPlayer").play("down")


func close_panel():
	queue_free()
	emit_signal("finish_one_talk")

func talk(iTalker, sValue):
	talker = iTalker
	value=sValue
	var name

	if iTalker == 0:
		name = "我"
	else:
		name = "妈妈"
func talk_now():
	get_node("NinePatchRect/label").bbcode_text = "[color=gray]"+name+":[/color] [bounce]"+value+"[/bounce]"
	get_node("NinePatchRect/label").time = 0
	startTime = OS.get_ticks_msec()
	bStart = true
	pass
