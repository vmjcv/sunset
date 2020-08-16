extends TextureRect
signal finish_talk

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var click_time = 0 
var can_click = true

func _showDuihua():
	pass
#	TalkMgr.talk(self, [[0, "妈妈最喜欢花了，如果给家里布置点花她一定会开心的！"]])

# Called when the node enters the scene tree for the first time.
func _ready():

	pass
#	var temp_timer=Timer.new()
#	add_child(temp_timer)
#	temp_timer.connect("timeout",self,"_showDuihua")
#	temp_timer.start(2)


func _on_jump_pressed():
	if not can_click:
		return 
#	if click_time==0:
#		TalkMgr.talk(self,[[0,"11111111111111"]])
	
	SceneMgr.changeScene("res://scene/juqing/3/juqing2.tscn")
	pass # Replace with function body.
