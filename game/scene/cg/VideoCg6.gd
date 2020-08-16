extends VideoPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	AudioPlayer.stop_bg()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VideoPlayer_finished():
	SceneMgr.changeScene('res://scene/start/menu.tscn')
	GlobalStatusMgr.zhoumu=1
	GlobalStatusMgr.levelFinsihList= {1:false, 2:false, 3:false, 4:false, 5:false}
	AudioPlayer.play_bg("菜单")
