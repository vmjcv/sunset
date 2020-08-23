extends Node2D


const STATUS_OPEN = 1
const STATUS_FINISH = 2

var status = STATUS_FINISH

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _setStatus(iZhoumu, dLevel):
	if iZhoumu > 1:
		status = STATUS_FINISH
	else:
		if dLevel[2]:
			status = STATUS_FINISH
		else:
			status = STATUS_OPEN
	
func resetStatus(iZhoumu, dLevel):
	_setStatus(iZhoumu, dLevel)
	
	if status == STATUS_FINISH:
		get_node("finish").modulate.a = 1
		get_node("open").modulate.a = 0
		get_node("jump").hide()
	else:
		get_node("finish").modulate.a = 0
		get_node("open").modulate.a = 1
		get_node("jump").show()

func updateStatus(iZhoumu, dLevel):
	_setStatus(iZhoumu, dLevel)
	
	if status == STATUS_FINISH:
		Fade.fade_out(get_node("finish"), GlobalConst.JUQING_FADE_SEC)
		Fade.fade_in(get_node("open"), GlobalConst.JUQING_FADE_SEC)
		get_node("jump").hide()
	else:
		Fade.fade_in(get_node("finish"), GlobalConst.JUQING_FADE_SEC)
		Fade.fade_out(get_node("open"), GlobalConst.JUQING_FADE_SEC)
		get_node("jump").show()

func beforeCG():
	get_node("finish").modulate.a = 0
	get_node("open").modulate.a = 1
	get_node("jump").hide()

func _on_btn_pressed():
	GlobalStatusMgr.goToLevel(2)
