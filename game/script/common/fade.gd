extends Node

var fadein_list = []
var fadeout_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var now = OS.get_ticks_msec()
	var new_fadein_list = []
	for fadeInfoList in fadein_list:
		if fadeInfoList[0] == null:
			continue
		var nowAlpha = float(now - fadeInfoList[2]) / 1000 / fadeInfoList[1] * (-fadeInfoList[3]) + fadeInfoList[3]
		fadeInfoList[0].modulate.a = nowAlpha
		if fadeInfoList[0].modulate.a<=0:
			fadeInfoList[0].modulate.a = 0
			if fadeInfoList[4] != null:
				fadeInfoList[4].call_func()
		else:
			new_fadein_list.append(fadeInfoList)
	fadein_list = new_fadein_list

	var new_fadeout_list = []
	for fadeInfoList in fadeout_list:
		if fadeInfoList[0] == null:
			continue
		var nowAlpha = float(now - fadeInfoList[2]) / 1000 / fadeInfoList[1] * (1-fadeInfoList[3]) + fadeInfoList[3]
		fadeInfoList[0].modulate.a = nowAlpha
		if fadeInfoList[0].modulate.a > 1:
			fadeInfoList[0].modulate.a = 1
			if fadeInfoList[4] != null:
				fadeInfoList[4].call_func()
		else:
			new_fadeout_list.append(fadeInfoList)
	fadeout_list = new_fadeout_list

func fade_in(node, iSec, callback = null):
	if node.modulate.a <= 0:
		return
	fadein_list.append([node, iSec, OS.get_ticks_msec(), node.modulate.a, callback])
	

func fade_out(node, iSec, callback = null):
	if node.modulate.a >= 1:
		return
	fadeout_list.append([node, iSec, OS.get_ticks_msec(), node.modulate.a, callback])
	
