extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var antModel: KinematicBody2D = $Ant
onready var isImmortal = false
onready var isMoveStatus = false
onready var posX	#tilemap坐标x
onready var posY	#tilemap坐标y
onready var towardX = 0	#移动x
onready var towardY = 0	#移动y
onready var towardTimes = 0	#移动次数


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_immortal(flag):
	isImmortal = flag
	
func get_immortal():
	return isImmortal
	
func set_map_index(x, y):
	posX = x
	posY = y
	
func get_map_index():
	return Vector2(posX, posY)
	
func get_model():
	return antModel
	
func set_move_times(times):
	towardTimes = times

func get_move_times():
	return towardTimes
	
func set_move_info(x, y):
	towardX = x
	towardY = y
	
func get_move_info():
	return Vector2(towardX, towardY)

func set_move_status(flag):
	isMoveStatus = flag
	
func get_move_status():
	return isMoveStatus
	
