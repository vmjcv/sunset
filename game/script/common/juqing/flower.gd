extends Node2D


const STATUS_OPEN = 1
const STATUS_FINISH = 2

var status = STATUS_FINISH

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func updateStatus(iZhoumu, dLevel):
	if iZhoumu > 1:
		status = STATUS_FINISH
	else:
		if dLevel[2]:
			status = STATUS_FINISH
		else:
			status = STATUS_OPEN
	
	if status == STATUS_FINISH:
		Fade.fade_out(get_node("finish"), GlobalConst.JUQING_FADE_SEC)
		get_node("open").hide()
	else:
		Fade.fade_in(get_node("finish"), GlobalConst.JUQING_FADE_SEC)
		get_node("open").show()

func _on_btn_pressed():
	GlobalStatusMgr.goToLevel(2)
