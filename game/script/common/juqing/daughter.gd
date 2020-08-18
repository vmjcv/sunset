extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("flower").modulate.a = 0
	get_node("rings").modulate.a = 0
	get_node("award").modulate.a = 0
	get_node("picture").modulate.a = 0
	pass # Replace with function body.

func resetStatus(iZhoumu, dLevel):
	pass
	
func updateStatus(iZhoumu, dLevel):
	pass

	
func showGift(sTag):
	hideNodes()
	
	Fade.fade_out(get_node(sTag), GlobalConst.JUQING_FADE_SEC)

	
func hideNodes():
	Fade.fade_in(get_node("flower"), GlobalConst.JUQING_FADE_SEC)
	Fade.fade_in(get_node("rings"), GlobalConst.JUQING_FADE_SEC)
	Fade.fade_in(get_node("award"), GlobalConst.JUQING_FADE_SEC)
	Fade.fade_in(get_node("picture"), GlobalConst.JUQING_FADE_SEC)
