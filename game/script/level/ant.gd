extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var isImmortal = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_immortal(flag):
	isImmortal = flag
	
func get_immortal():
	return isImmortal
