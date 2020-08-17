extends Node2D

signal finish_talk

const STATUS_OPEN = 1
const STATUS_CLOSE = 2

var status = STATUS_CLOSE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func updateStatus(iZhoumu, dLevel):
	if iZhoumu > 1:
		status = STATUS_CLOSE
	else:
		if dLevel[1]:
			status = STATUS_CLOSE
		else:
			status = STATUS_OPEN
	
	if status == STATUS_CLOSE:
		get_node("chouti").hide()
		Fade.fade_out(get_node("finish"), GlobalConst.JUQING_FADE_SEC)
	else:
		Fade.fade_out(get_node("finish"), GlobalConst.JUQING_FADE_SEC)
		get_node("chouti").show()

func _do_talk():
	GlobalStatusMgr.goToLevel(1)

func _on_chouti_pressed():
	connect("finish_talk", self, "_do_talk")
	TalkMgr.talk(self, [[0, "妈妈看到我的好成绩，一定会高兴的吧！"]])
	
