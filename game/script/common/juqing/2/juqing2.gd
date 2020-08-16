extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var temp_timer

func _do_talk():
	SceneMgr.changeScene("res://scene/juqing/2/juqing3.tscn")

func _showDuihua():
	connect("finish_talk", self, "_do_talk")
	TalkMgr.talk(self, [[0, "妈妈！看这个花漂亮吧~"]])
	temp_timer.stop()

# Called when the node enters the scene tree for the first time.
func _ready():
	temp_timer=Timer.new()
	add_child(temp_timer)
	temp_timer.connect("timeout",self,"_showDuihua")
	temp_timer.start(0.2)


#func _input(event):
#	if event is InputEventMouseButton:
#		if event.button_index == BUTTON_LEFT and event.pressed:
#			SceneMgr.changeScene("res://scene/juqing/2/juqing3.tscn")

func finishLevel(i, ii):
	pass
