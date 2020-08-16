extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func updateStatus(iZhoumu, dLevel):
	pass
	
	
func showGift(sTag):
	get_node("flower").hide()
	get_node("rings").hide()
	get_node("award").hide()
	get_node("picture").hide()
	
	get_node(sTag).show()

	
func hideNodes():
	get_node("flower").hide()
	get_node("rings").hide()
	get_node("award").hide()
	get_node("picture").hide()
