extends Node2D

const STATUS_CLOSE = 1
const STATUS_OPEN = 2
const STATUS_FINISH = 3

var status = STATUS_CLOSE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func updateStatus(iZhoumu, dLevel):
	var nowStatus
	if iZhoumu > 1:
		nowStatus = STATUS_FINISH
	else:
		if not dLevel[1] or not dLevel[2]:
			nowStatus = STATUS_CLOSE
		elif dLevel[3]:
			nowStatus = STATUS_FINISH
		else:
			nowStatus = STATUS_OPEN
	
	if nowStatus == status:
		return
	status = nowStatus
	
	Fade.fade_in(get_node("close"), GlobalConst.JUQING_FADE_SEC)
	Fade.fade_in(get_node("open"), GlobalConst.JUQING_FADE_SEC)
	Fade.fade_in(get_node("finish"), GlobalConst.JUQING_FADE_SEC)
	get_node("jump").hide()
	if status == STATUS_CLOSE:
		Fade.fade_out(get_node("close"), GlobalConst.JUQING_FADE_SEC)
	elif status == STATUS_OPEN:
		Fade.fade_out(get_node("open"), GlobalConst.JUQING_FADE_SEC)
		get_node("jump").show()
	else:
		Fade.fade_out(get_node("finish"), GlobalConst.JUQING_FADE_SEC)


func _on_jump_pressed():
	GlobalStatusMgr.goToLevel(3)
