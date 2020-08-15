extends TextureRect



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_start_pressed():
	SceneMgr.goDownScene('res://scene/start/room.tscn')
