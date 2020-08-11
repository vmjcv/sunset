extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal open


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(5):
		get_parent().connect("door_opened",self,"callback",[i,123,41])
	pass # Replace with function body.

func callback(param1,param2,param3,param4):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
