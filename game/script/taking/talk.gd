extends Node2D

var startTime = 0
var bStart = false
const allTime = 2

func _ready():
	talk(1, "mom, i want to eat child and monster,,, why do not eat child....")
	pass # Replace with function body.

func _process(delta):
	if not bStart:
		return
	var cal =  (OS.get_ticks_msec() - startTime) / allTime
	if cal > 1000:
		get_node("label").time = 1
		bStart = false
		return
	get_node("label").time = float(cal) / 1000

func talk(iTalker, sValue):
	var sp
	if iTalker == 0:
		sp = get_node("mom")
	else:
		sp = get_node("daughter")
	sp.show()
	get_node("label").bbcode_text = "[color=gray]bounce:[/color] [bounce]"+sValue+"[/bounce]"
	get_node("label").time = 0
	startTime = OS.get_ticks_msec()
	bStart = true
