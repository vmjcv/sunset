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
	SceneMgr.changeScene('res://scene/juqing/3/juqing1.tscn')
	GlobalStatusMgr.nextZhoumu()
	AudioPlayer.play_bg("3-1")
