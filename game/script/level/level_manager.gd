extends Container

var globalVar = load("res://script/common/global.gd")
var pressed_status = false
var birthPos = []
var ants = []
var trapped = {}
var swallowed = {}
var tileIdMap = {}
var itemList = {}
enum {UP,DOWN,LEFT,RIGHT}

onready var tileMap : TileMap
onready var curLevel
onready var curZhoumu
onready var specialWay = false
onready var tilemap_item={}

var round_time =0

signal match_result
signal fail

var ant_path="res://scene/level/ant.tscn"

# Called when the node enters the scene tree for the first time.

func set_map_id(level, zhoumu):
	curLevel = level
	curZhoumu = zhoumu
	if curLevel == null or curZhoumu == null:
		curLevel = 1
		curZhoumu = 1
	_add_map(curLevel, curZhoumu)
	for cord in tileMap.get_used_cells():
		for type in globalVar.BIRTHPOS:
			var tileID = tileMap.get_cell(cord[0], cord[1])
			if tileID == tileIdMap[type]:
				birthPos.append(cord)

	var isSpecialAnt = GlobalStatusMgr.is_special_ant(curLevel, curZhoumu)
	if isSpecialAnt:
		pass
	else:
		for pos in birthPos:
			var ant_scene = load(ant_path)
			var ant_instance = ant_scene.instance()
			ant_instance.set_map_index(pos.x, pos.y)
			add_child(ant_instance)
			ants.append(ant_instance)
			ant_instance.position=(pos*64)+Vector2(32,32)
			ant_instance.round_time = round_time
			ant_instance.set_ant1()

func _add_map(level,zhoumu):
	itemList.clear()
	for node in get_children():
		remove_child(node)
	var path="res://scene/map/map_%s_%s.tscn"%[zhoumu,level]
	var tile_map_res = load(path)
	tileMap = tile_map_res.instance()
	add_child(tileMap)
	
	tilemap_item = tileMap.dict
	
	for TileId in tileMap.tile_set.get_tiles_ids():
		tileIdMap[tileMap.tile_set.tile_get_name(TileId)] = TileId

func get_tile_item(k):
	var item = tilemap_item.get(String(k),null)
	return item

func _ready():
	pass

func _process(delta):
	var length=0
	var have_move = false
	for ant in ants:
		if ant.get_move_status() and ant.round_time<=round_time:
			have_move = true
			length=length+1
			var move_info = ant.get_move_info()
			var move_times = ant.get_move_times()
			ant.position = ant.position+Vector2(move_info.x,move_info.y)
			
			match ant.now_status:
				DOWN:
					ant.turn_down()
				LEFT:
					ant.turn_left()
				RIGHT:
					ant.turn_right()
				UP:
					ant.turn_up()
			
			move_times = move_times - 1
			ant.set_move_times(move_times)
			if move_times <= 0:
				ant.set_move_status(false)
				check_ant_status(ant)
				check_pass()
				length=length-1

	if length<=0 and have_move:
		for ant in ants:
			if ant.now_status>-1:
				move_turn(ant.now_status)
				break

func _input(event):
	var isMoving = false
	for ant in ants:
		if ant.get_move_status():
			isMoving = true
	if isMoving:
		return
	else:
		round_time = round_time + 1
		for ant in ants:
			ant.round_time = round_time
		var index = 0
		while index < ants.size():
			if ants[index].get_isDie():
				ants.remove(index)
			else:
				index = index + 1
		
	if Input.is_action_pressed('ui_up'):
		move_turn(UP)
	elif Input.is_action_pressed('ui_down'):
		move_turn(DOWN)
	elif Input.is_action_pressed('ui_left'):
		move_turn(LEFT)
	elif Input.is_action_pressed('ui_right'):
		move_turn(RIGHT)
		
func my_input(movement):
	var isMoving = false
	for ant in ants:
		if ant.get_move_status():
			isMoving = true
	if isMoving:
		return
	else:
		round_time = round_time + 1
		for ant in ants:
			ant.round_time = round_time
		var index = 0
		while index < ants.size():
			if ants[index].get_isDie():
				ants.remove(index)
			else:
				index = index + 1
	if movement == 'ui_up':
		move_turn(UP)
	elif movement == 'ui_down':
		move_turn(DOWN)
	elif movement == 'ui_left':
		move_turn(LEFT)
	elif movement == 'ui_right':
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
	
	for ant in ants:
		if ant.round_time >round_time:
			continue
		
		var mapIndex = ant.get_map_index()
		var dict_index = mapIndex.x*100+mapIndex.y
		if not itemList.keys().has(dict_index):
			var item = get_tile_item(dict_index)
			if item != null:
				ItemManage.show_item_talk(item.item_name)
				item.hide()
				itemList[dict_index] = item

		var cur = mapIndex+turn_vector2
		ant.now_status = turn
		if ant.get_isTrapped() or ant.get_isSwallowed() or ant.get_isDie() or check_block_type(cur.x, cur.y):
			if ant.now_status!=-1:
				ant.round_time = round_time+1
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
		
		var move_info = turn_vector2*4
		ant.set_move_info(move_info.x, move_info.y)
		ant.set_move_times(Offset*16)
		
	return can_move

func check_ant_status(ant):
	var curPos = ant.get_map_index()
	var dict_key = curPos.x * 100 + curPos.y
	var tileId = tileMap.get_cell(curPos.x, curPos.y)
	var tileName = tileMap.tile_set.tile_get_name(tileId)
	
	if globalVar.DESTINATION.has(tileName) and not trapped.keys().has(dict_key):
		ant.set_isTrapped(true)
		trapped[dict_key] = true
	if tileName == "trap1" and not trapped.keys().has(dict_key):
		ant.set_isTrapped(true)
		trapped[dict_key] = true
	elif tileName == "trap2" and not swallowed.keys().has(dict_key):
		ant.set_isSwallowed(true)
		swallowed[dict_key] = true
		ant.hide()
		tileMap.set_cell(curPos.x, curPos.y, tileIdMap["trap3"])
	if globalVar.HOLE.has(tileName):
		ant.set_isDie(true)

func get_all_grids_number():
	var dict = {}
	for ant in ants:
		if not ant.get_isTrapped() and not ant.get_isSwallowed():
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
	if globalVar.WALL.has(tileName):
		if tileName == "wall1":
			tileMap.set_cell(x, y, tileIdMap["wall2"])
		elif tileName == "wall2":
			tileMap.set_cell(x, y, tileIdMap["wall3"])
		elif tileName == "wall3":
			tileMap.set_cell(x, y, tileIdMap["plain"])
		return true
	if temp_dict.keys().has(dict_key):
		return true
	if (tileName == "trap1" or globalVar.DESTINATION.has(tileName)) and trapped.keys().has(dict_key):
		return true
	if tileName == "trap3" and swallowed.keys().has(dict_key):
		return false
	if globalVar.BROKEN.has(tileName):
		if tileName == "broken1":
			tileMap.set_cell(x, y, tileIdMap["broken2"])
		elif tileName == "broken2":
			tileMap.set_cell(x, y, tileIdMap["broken3"])
		elif tileName == "broken3":
			tileMap.set_cell(x, y, tileIdMap["hole"])
		return false
	return false
		
func check_pass():
	var successNum = 0
	for ant in ants:
		var pos = ant.get_map_index()
		var dict_key = pos.x * 100 + pos.y
		var tileId = tileMap.get_cell(pos.x, pos.y)
		var tileName = tileMap.tile_set.tile_get_name(tileId)
		if tileName == "destination":
			successNum = successNum + 1
		elif tileName == "door":
			successNum = successNum + 1
			specialWay = true
	#暂时写1，之后条件会读取配置
	if successNum >= 1:
		show_pass()


func show_pass():
	var game_over = preload("res://scene/common/game_over.tscn")
	var panel = game_over.instance()
	panel.specialWay= specialWay
	add_child(panel)
	panel.get_item_list(itemList,true)
	#确认后发送事件
	#emit_signal("success")
	
func show_fail():
	pass
	#确认后发送事件
	#emit_signal("fail")

func replay():
	GlobalStatusMgr.goToLevel(curLevel)
		
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

