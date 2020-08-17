extends Node2D

const STATUS_0 = 0
const STATUS_1 = 1
const STATUS_2 = 2
const STATUS_3 = 3

var status = STATUS_1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _reset():
	Fade.fade_in(get_node("status1"), GlobalConst.JUQING_FADE_SEC)
	Fade.fade_in(get_node("status2"), GlobalConst.JUQING_FADE_SEC)
	Fade.fade_in(get_node("status3"), GlobalConst.JUQING_FADE_SEC)

func updateStatus(iZhoumu, dLevel):
	var nowStatus
	if iZhoumu > 1:
		nowStatus = STATUS_3
	else:
		if dLevel[5]:
			nowStatus = STATUS_3
		else:
			nowStatus = STATUS_1
	
	if nowStatus == status:
		return
	status = nowStatus
	
	_reset()
	if status == STATUS_1:
		Fade.fade_out(get_node("status1"), GlobalConst.JUQING_FADE_SEC)
	elif status == STATUS_2:
		Fade.fade_out(get_node("status2"), GlobalConst.JUQING_FADE_SEC)
	elif status == STATUS_3:
		Fade.fade_out(get_node("status3"), GlobalConst.JUQING_FADE_SEC)
		
func showStatus1():
	if status == STATUS_1:
		return
	_reset()
	Fade.fade_out(get_node("status1"), GlobalConst.JUQING_FADE_SEC)

func showStatus2():
	if status == STATUS_2:
		return
	_reset()
	Fade.fade_out(get_node("status2"), GlobalConst.JUQING_FADE_SEC)
	
func showStatus3():
	if status == STATUS_3:
		return
	_reset()
	Fade.fade_out(get_node("status3"), GlobalConst.JUQING_FADE_SEC)
