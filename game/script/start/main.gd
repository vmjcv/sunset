extends TextureRect

var nStartSlipTime = 0
var slipTime = 300
var curposi = null
var sp
const sceneH = 580
var bSlipAction = false

# Called when the node enters the scene tree for the first time.
func _ready():
	sp = get_node("sp")


func _process(time):
	if not bSlipAction:
		return
	if OS.get_ticks_msec() - nStartSlipTime > slipTime:
		set_process(false)
		SceneMgr.changeScene('res://scene/juqing/1/juqing1.tscn').updateStatus()
		return
	var changeH = sceneH * (OS.get_ticks_msec() - nStartSlipTime) / slipTime
	sp.position = Vector2(curposi.x, curposi.y + changeH)


func _on_start_pressed():
	bSlipAction = true
	nStartSlipTime = OS.get_ticks_msec()
	curposi = sp.position
