extends Panel

var globalVar = load("res://script/common/global.gd")
var pressed_status = false
var maxW = 0
var maxH = 0
var birthPos = []
var ants = []
onready var tileMap = get_node("TileMap")
enum {UP,DOWN,LEFT,RIGHT}


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
		move_turn(UP)
	elif Input.is_action_pressed('ui_down'):
		move_turn(DOWN)
	elif Input.is_action_pressed('ui_left'):
		move_turn(LEFT)
	elif Input.is_action_pressed('ui_right'):
		move_turn(RIGHT)
		
func move_turn(turn):
	var turn_vector2
	match turn:
		RIGHT:
			turn_vector2=Vector2(1,0)
			pass
		LEFT:
			turn_vector2=Vector2(-1,0)
			pass
		DOWN:
			turn_vector2=Vector2(0,1)
			pass
		UP:
			turn_vector2=Vector2(0,-1)
	_sort_by_xy(ants,turn)
	var temp_dict=get_all_grids_number()

	for ant in ants:
		var mapIndex = ant.get_map_index()

		var cur = mapIndex+turn_vector2
		var cur_index =cur.x*100+cur.y
		if check_block_type(cur.x, cur.y) or temp_dict.keys().has(cur_index):
			continue
		
		var Offset = 0
		while not check_block_type(cur.x, cur.y) and not temp_dict.keys().has(cur_index):
			cur =cur +turn_vector2
			Offset = Offset + 1
			break
		cur =cur -turn_vector2
		ant.set_map_index(cur.x, cur.y)
		ant.set_move_status(true)
		
		var move_info = turn_vector2*8
		ant.set_move_info(move_info.x, move_info.y)
		ant.set_move_times(Offset*8)
	
	
func get_all_grids_number():
	var dict = {}
	for ant in ants:
		var mapIndex = ant.get_map_index()
		dict[mapIndex.x*100+mapIndex.y] = ant
	return dict
func check_block_type(x, y):
	for type in globalVar.OBSTACLE:
		if tileMap.get_cell(x, y) == type:
			return true
			
	for type in globalVar.OBSTACLE:
		if tileMap.get_cell(x, y) == type:
			return true

	return false
		
func check_pass():
	var successNum = 0
	for ant in ants:
		var pos = ant.get_map_index()
		for type in globalVar.DESTINATION:
			if tileMap.get_cell(pos.x, pos.y) == type:
				successNum = successNum + 1
	#暂时写1，之后条件会读取配置
	if successNum >= 1:
		print("通关啦!!!!!!!!!!!!!!!!")
		
class MyCustomSorter:
	static func _sort_by_x(a, b):
		if a.get_map_index().x<b.get_map_index().x:
			return true
		return false	
	static func _sort_by_x2(a, b):
		if a.get_map_index().x>=b.get_map_index().x:
			return true
		return false	
	static func _sort_by_y(a, b):
		if a.get_map_index().y>=b.get_map_index().y:
			return true
		return false	
	static func _sort_by_y2(a, b):
		if a.get_map_index().y<b.get_map_index().y:
			return true
		return false	
		

func _sort_by_xy(cell_list,turn):
	match turn:
		UP:
			cell_list.sort_custom(MyCustomSorter,"_sort_by_y2")
		DOWN:
			cell_list.sort_custom(MyCustomSorter,"_sort_by_y")
		LEFT:
			cell_list.sort_custom(MyCustomSorter,"_sort_by_x2")
		RIGHT:
			cell_list.sort_custom(MyCustomSorter,"_sort_by_x")

