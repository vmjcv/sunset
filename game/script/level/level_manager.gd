extends Node2D

var globalVar = load("res://script/common/global.gd")
var maxW = 0
var maxH = 0
var birthPos = []
onready var tileMap = get_node("TileMap")

var ant_path="res://scene/level/ant.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	for cord in tileMap.get_used_cells():
		maxW = max(cord[0], maxW)
		maxH = max(cord[1], maxH)
		for type in globalVar.BIRTHPOS:
			if tileMap.get_cell(cord[0], cord[1]) == type:
				birthPos.append(cord)
	print(birthPos)
	for pos in birthPos:
		var ant_scene = load(ant_path)
		var ant_instance = ant_scene.instance()
		add_child(ant_instance)
		ant_instance.position=(pos*64)+Vector2(32,32)
		pass
