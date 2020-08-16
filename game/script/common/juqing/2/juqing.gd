extends TextureRect


# Declare member variables here. Examples:
# var a = 2
var temp_timer

func _showDuihua():
	TalkMgr.talk(self, [[0, "如果爸爸妈妈都没时间打理植物的话，那只要花永远都不会枯萎就行了！"]])
	temp_timer.stop()

# Called when the node enters the scene tree for the first time.
func _ready():
	temp_timer=Timer.new()
	add_child(temp_timer)
	temp_timer.connect("timeout",self,"_showDuihua")
	temp_timer.start(1)


func _on_jump_pressed():
	GlobalStatusMgr.goToLevel(1)
