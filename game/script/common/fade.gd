extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var fadein_list = []
var fadeout_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	for node in fadein_list:
		node[0].modulate.a = node[0].modulate.a - 0.5*delta
		if node[0].modulate.a<=0:
			fadein_list.erase(node)

	for node in fadeout_list:
		node[0].modulate.a = node[0].modulate.a + 0.5*delta
		if node[0].modulate.a>=1:
			fadeout_list.erase(node)

func fade_in(node,callback):
	fadein_list.append([node,callback])
	

func fade_out(node,callback):
	fadeout_list.append([node,callback])
	
