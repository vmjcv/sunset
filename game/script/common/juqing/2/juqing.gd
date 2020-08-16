extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _showDuihua():
	TalkMgr.talk(self, [[0, "妈妈最喜欢花了，如果给家里布置点花她一定会开心的！"]])

# Called when the node enters the scene tree for the first time.
func _ready():
	var temp_timer=Timer.new()
	add_child(temp_timer)
	temp_timer.connect("timeout",self,"_showDuihua")
	temp_timer.start(2)


func _on_jump_pressed():
	pass # Replace with function body.
