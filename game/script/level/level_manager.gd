extends Panel

var globalVar = load("res://script/common/global.gd")
var pressed_status = false
var birthPos = []
var trappedAntPos = {}
var ants = []
var tileIdMap = {}
enum {UP,DOWN,LEFT,RIGHT}

onready var tileMap : TileMap
onready var curLevel
onready var curZhoumu

signal success
signal fail

var ant_path="res://scene/level/ant.tscn"

# Called when the node enters the scene tree for the first time.

func set_map_id(level, zhoumu):
	curLevel = level
	curZhoumu = zhoumu

func _add_map(level,zhoumu):
	for node in get_children():
		remove_child(node)
	var path="res://scene/map/map_%s_%s.tscn"%[level,zhoumu]
	var tile_map_res = load(path)
	tileMap = tile_map_res.instance()
	add_child(tileMap)
	for TileId in tileMap.tile_set.get_tiles_ids():
		tileIdMap[tileMap.tile_set.tile_get_name(TileId)] = TileId

func _ready():
	if curLevel == null or curZhoumu == null:
		curLevel = 1
		curZhoumu = 1
	_add_map(curLevel, curZhoumu)
	for cord in tileMap.get_used_cells():
		for type in globalVar.BIRTHPOS:
			var tileID = tileMap.get_cell(cord[0], cord[1])
			if tileID == tileIdMap[type]:
				birthPos.append(cord)

	for pos in birthPos:
		var ant_scene = load(ant_path)
		var ant_instance = ant_scene.instance()
		ant_instance.set_map_index(pos.x, pos.y)
		add_child(ant_instance)
		ants.append(ant_instance)
		ant_instance.position=(pos*64)+Vector2(32,32)

func _process(delta):
	var length=0
	var have_move = false
	for ant in ants:
		if ant.get_move_status():
			have_move = true
			length=length+1
			var move_info = ant.get_move_info()
			var move_times = ant.get_move_times()
			ant.position = ant.position+Vector2(move_info.x,move_info.y)
			move_times = move_times - 1
			ant.set_move_times(move_times)
			if move_times <= 0:
				ant.set_move_status(false)
				check_ant_status(ant)
				length=length-1

	var need_check = true
	if length<=0 and have_move:
		for ant in ants:
			if ant.now_status>-1:
				need_check=false
				need_check = not move_turn(ant.now_status)
				break
		if  need_check:
			check_pass()

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
	
	var can_move =false
	var index = 0
	while index < ants.size():
		if ants[index].get_isDie():
			ants.remove(index)
		else:
			index = index + 1
	
	for ant in ants:
		var mapIndex = ant.get_map_index()
	
		var cur = mapIndex+turn_vector2
		ant.now_status = turn
		if ant.get_isTrapped() or check_block_type(cur.x, cur.y):
			ant.now_status = -1
			continue
		
		var Offset = 0
		while not check_block_type(cur.x, cur.y):
			cur = cur + turn_vector2
			Offset = Offset + 1
			can_move = true
			break
		cur =cur -turn_vector2
		ant.set_map_index(cur.x, cur.y)
		ant.set_move_status(true)
		
		var move_info = turn_vector2*8
		ant.set_move_info(move_info.x, move_info.y)
		ant.set_move_times(Offset*8)
		
	return can_move

func check_ant_status(ant):
	var curPos = ant.get_map_index()
	var dict_key = curPos.x * 100 + curPos.y
	var tileId = tileMap.get_cell(curPos.x, curPos.y)
	var tileName = tileMap.tile_set.tile_get_name(tileId)
	
	if globalVar.TRAP.has(tileName) and not trappedAntPos.keys().has(dict_key):
		ant.set_isTrapped(true)
		trappedAntPos[dict_key] = ant
	if globalVar.HOLE.has(tileName):
		ant.set_isDie(true)

func get_all_grids_number():
	var dict = {}
	for ant in ants:
		var mapIndex = ant.get_map_index()
		dict[mapIndex.x*100+mapIndex.y] = ant
	return dict

func check_block_type(x, y):
	var temp_dict=get_all_grids_number()
	var dict_key = x * 100 + y
	var tileId = tileMap.get_cell(x, y)
	var tileName = tileMap.tile_set.tile_get_name(tileId)
	
	if globalVar.OBSTACLE.has(tileName):
		return true
	if globalVar.PLAIN.has(tileName) and temp_dict.keys().has(dict_key):
		return true
	if globalVar.DESTINATION.has(tileName) and temp_dict.keys().has(dict_key):
		return true
	if globalVar.WALL.has(tileName):
#		var cellKey = tileMap.tile_set.tile_get_name()
		#tileMap.set_cell(x, y, cellKy)
		return true
	return false
		
func check_pass():
	var successNum = 0
	for ant in ants:
		var pos = ant.get_map_index()
		var tileId = tileMap.get_cell(pos.x, pos.y)
		var tileName = tileMap.tile_set.tile_get_name(tileId)
		if globalVar.DESTINATION.has(tileName):
			successNum = successNum + 1
	#暂时写1，之后条件会读取配置
	if successNum >= 1:
		show_pass()


func show_pass():
	print("通关啦!!!!!!!!!!!!!!!!")
	#点击后发送事件
	#emit_signal("success")
		
class MyCustomSorter:
	static func _sort_by_x(a, b):
		if a.get_map_index().x>b.get_map_index().x:
			return true
		return false	
	static func _sort_by_x2(a, b):
		if a.get_map_index().x<=b.get_map_index().x:
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

