extends TextureRect



# Called when the node enters the scene tree for the first time.
func _ready():
	#TalkMgr.talk([[0, "123213213"], [1, "duqwhufod21d12d21d21d21de"]])
	pass # Replace with function body.




func _on_start_pressed():
	SceneMgr.goDownScene('res://scene/juqing/1/juqing1.tscn').updateStatus()
