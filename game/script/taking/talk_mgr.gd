extends Node
signal finish_talk
var panel

func _ready():
	pass # Replace with function body.
	
func talk(talking_list):
	panel = load('res://scene/talking/talking.tscn').instance()
	get_tree().get_root().add_child(panel)
	panel.add_talk_list(talking_list)
	panel.talk_begin()
	panel.connect("finish_talk",self,"finish_talk")
	
	
func finish_talk():
	emit_signal("finish_talk")
	
