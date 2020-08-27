extends Node
signal finish_talk
var panel

var talking_panel = preload('res://scene/talking/talking.tscn')

func _ready():
	pass # Replace with function body.
	
func talk(talking_list):
	panel = talking_panel.instance()
	get_tree().get_root().add_child(panel)
	panel.add_talk_list(talking_list)
	panel.connect("finish_talk",self,"finish_talk")
	panel.talk_begin()

	
func finish_talk():
	emit_signal("finish_talk")

	
