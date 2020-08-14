extends Node2D

var globalVar = load("res://script/common/global.gd")
var maxW = 0
var maxH = 0
var birthPos = []
onready var tileMap = get_node("TileMap")

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
		pass
