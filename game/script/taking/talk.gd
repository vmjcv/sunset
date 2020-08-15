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
	var sp

#	if iTalker == 0:
#		sp = get_node("mom")
#	else:
#		sp = get_node("daughter")
#	sp.show()
func talk_now():
	get_node("NinePatchRect/label").bbcode_text = "[color=gray]bounce:[/color] [bounce]"+value+"[/bounce]"
	get_node("NinePatchRect/label").time = 0
	startTime = OS.get_ticks_msec()
	bStart = true
	pass
