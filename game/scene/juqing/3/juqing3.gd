extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal finish_talk
var click_time = 0 
var can_click = true

func _showDuihua():
	connect("finish_talk", self, "_do_talk1")
	TalkMgr.talk(self, [[0, "不..."]])

# Called when the node enters the scene tree for the first time.
func _ready():
	var temp_timer=Timer.new()
	add_child(temp_timer)
	temp_timer.connect("timeout",self,"_showDuihua")
	temp_timer.start(2)



func _do_talk1():
	SceneMgr.changeSceneFade("res://scene/juqing/3/juqing4.tscn")
