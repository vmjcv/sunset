extends Panel

var globalVar = load("res://script/common/global.gd")
var pressed_status = false
var maxW = 0
var maxH = 0
var birthPos = []
var ants = []
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
		ant_instance.set_map_index(pos.x, pos.y)
		add_child(ant_instance)
		ants.append(ant_instance)
		ant_instance.position=(pos*64)+Vector2(32,32)
	

func _process(delta):
	for ant in ants:
		if ant.get_move_status():
			var move_info = ant.get_move_info()
			var move_times = ant.get_move_times()
			ant.position = ant.position+Vector2(move_info.x,move_info.y)
			move_times = move_times - 1
			ant.set_move_times(move_times)
			if move_times <= 0:
				ant.set_move_status(false)
			

func _input(event):
	var isMoving = false
	for ant in ants:
		if ant.get_move_status():
			isMoving = true
	if isMoving:
		return
	if Input.is_action_pressed('ui_up'):
		move_up()
	elif Input.is_action_pressed('ui_down'):
		move_down()
	elif Input.is_action_pressed('ui_left'):
		move_left()
	elif Input.is_action_pressed('ui_right'):
		move_right()
			
func move_up():
	for ant in ants:
		var mapIndex = ant.get_map_index()
		var curX = mapIndex.x
		var curY = mapIndex.y - 1
		if check_block_type(curX, curY, 5):
			return
		var Offset = 0
		while not check_block_type(curX, curY, 5) :
			curY = curY - 1
			Offset = Offset + 1
		ant.set_map_index(curX, curY)
		ant.set_move_status(true)
		ant.set_move_info(0, -8)
		ant.set_move_times(Offset*8)
	
func move_left():
	for ant in ants:
		var mapIndex = ant.get_map_index()
		var curX = mapIndex.x - 1
		var curY = mapIndex.y
		if check_block_type(curX, curY, 5):
			return
		var Offset = 0
		while not check_block_type(curX, curY, 5) :
			curX = curX - 1
			Offset = Offset + 1
		ant.set_map_index(curX, curY)
		ant.set_move_status(true)
		ant.set_move_info(-8, 0)
		ant.set_move_times(Offset*8)
	
func move_right():
	for ant in ants:
		var mapIndex = ant.get_map_index()
		var curX = mapIndex.x + 1
		var curY = mapIndex.y
		if check_block_type(curX, curY, 5):
			return
		var Offset = 0
		while not check_block_type(curX, curY, 5) :
			curX = curX + 1
			Offset = Offset + 1
		ant.set_map_index(curX, curY)
		ant.set_move_status(true)
		ant.set_move_info(+8, 0)
		ant.set_move_times(Offset*8)
	
func move_down():
	for ant in ants:
		var mapIndex = ant.get_map_index()
		var curX = mapIndex.x
		var curY = mapIndex.y + 1
		if check_block_type(curX, curY, 5):
			return
		var Offset = 0
		while not check_block_type(curX, curY, 5) :
			curY = curY + 1
			Offset = Offset + 1
		ant.set_map_index(curX, curY)
		ant.set_move_status(true)
		ant.set_move_info(0, 8)
		ant.set_move_times(Offset*8)
	
func check_block_type(x, y, type):
	if tileMap.get_cell(x, y) == type:
		return true
	else:
		return false
