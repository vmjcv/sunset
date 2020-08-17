extends Node2D

const STATUS_NORMAL = 1
const STATUS_SAD = 2

var status = STATUS_NORMAL

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func updateStatus(iZhoumu, dLevel):
	if iZhoumu > 1 or dLevel[5]:
		status = STATUS_SAD
	else:
		status = STATUS_NORMAL
	
	if status == STATUS_NORMAL:
		Fade.fade_out(get_node("statu1"), GlobalConst.JUQING_FADE_SEC)
		Fade.fade_in(get_node("statu2"), GlobalConst.JUQING_FADE_SEC)
	elif status == STATUS_SAD:
		Fade.fade_out(get_node("statu2"), GlobalConst.JUQING_FADE_SEC)
		Fade.fade_in(get_node("statu1"), GlobalConst.JUQING_FADE_SEC)

