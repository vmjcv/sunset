extends TextureRect

var startTime = 0
const allTime = 3
var talker
var value
var nameStr
signal finish_one_talk

func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if get_node("NinePatchRect/RichTextLabel").time < 1:
				#get_node("NinePatchRect/RichTextLabel").time = 1
#				emit_signal("finish_one_talk")
#				close_panel()
				pass
			else:
				get_node("AnimationPlayer").play("down")


func close_panel():
	queue_free()
	emit_signal("finish_one_talk")

func talk(iTalker, sValue):
	talker = iTalker
	value=sValue

	if iTalker == 0:
		nameStr = "我"
	else:
		nameStr = "妈妈"
		
func talk_now():
	get_node("NinePatchRect/RichTextLabel").bbcode_text = "[color=gray]"+nameStr+":[/color] [bounce id=talk]"+value+"[/bounce]"
	get_node("NinePatchRect/RichTextLabel").fade_in()
	pass
