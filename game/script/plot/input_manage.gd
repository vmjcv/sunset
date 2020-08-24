extends Node

var now_click 

func _ready():
	pass

func mouse_entered(node):
	now_click = node
	
func mouse_exited(node):
	if now_click == node:
		now_click = null


func mouse_click():
	if now_click:
		now_click.click()

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed==false:
		mouse_click()
