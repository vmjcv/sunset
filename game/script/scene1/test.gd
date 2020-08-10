extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	EventChainGraphManage.add_graph("test","res://scene/scene1/EventChainGraph.tscn")
	EventChainSignalManage.register_all_signals()
	EventChainSignalManage.emit("open_door")
	
	
	EventChainManage.add_key("happy",obj)
	EventChainManage.add_dict("happy",obj)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
