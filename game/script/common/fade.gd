extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var fadein_list = []
var fadeout_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var now = OS.get_ticks_msec()
	for fadeInfoList in fadein_list:
		var nowAlpha = float(now - fadeInfoList[2]) / 1000 / fadeInfoList[1] * (-fadeInfoList[3]) + fadeInfoList[3]
		fadeInfoList[0].modulate.a = nowAlpha
		if fadeInfoList[0].modulate.a<=0:
			fadeInfoList[0].modulate.a = 0
			fadein_list.erase(fadeInfoList)
			if fadeInfoList[4] != null:
				fadeInfoList[4].call_func()

	for fadeInfoList in fadeout_list:
		var nowAlpha = float(now - fadeInfoList[2]) / 1000 / fadeInfoList[1] * (1-fadeInfoList[3]) + fadeInfoList[3]
		fadeInfoList[0].modulate.a = nowAlpha
		if fadeInfoList[0].modulate.a > 1:
			fadeInfoList[0].modulate.a = 1
			fadeout_list.erase(fadeInfoList)
			if fadeInfoList[4] != null:
				fadeInfoList[4].call_func()

func fade_in(node, iSec, callback = null):
	fadein_list.append([node, iSec, OS.get_ticks_msec(), node.modulate.a, callback])
	

func fade_out(node, iSec, callback = null):
	fadeout_list.append([node, iSec, OS.get_ticks_msec(), node.modulate.a, callback])
	
