extends Node

var last_scene = null
var current_scene = null

#预加载场景
var perload_scene_map = {}

# 后台加载
var loader
var wait_frames
var time_max = 100 # msec

# 上下切换动画
var bSlipAction = false
var nStartSlipTime = 0
var lastSceneposi = null
var curSceneposi = null
var slipTime = 300
const sceneH = 1080

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func _process(time):
	if bSlipAction:
		if OS.get_ticks_msec() - nStartSlipTime > slipTime:
			last_scene.queue_free()
			get_tree().set_current_scene(current_scene)
			current_scene.rect_position = curSceneposi
			set_process(false)
			return
		var changeH = sceneH * (OS.get_ticks_msec() - nStartSlipTime) / slipTime
		current_scene.rect_position = Vector2(curSceneposi.x, curSceneposi.y + sceneH - changeH)
		last_scene.rect_position = Vector2(lastSceneposi.x, lastSceneposi.y - changeH)
	
#	后台加载
	if loader == null:
		return

	if wait_frames > 0:
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max:
		var err = loader.poll()

		if err == ERR_FILE_EOF: 
			var resource = loader.get_resource()
			loader = null
			break
		elif err == OK:
			pass
		else: 
			loader = null
			break

func _loadPanel(path):
	var s = ResourceLoader.load(path)
	var ins = s.instance()
	current_scene.add_child(ins)
	return ins

func _deferred_goto_scene(path):
	current_scene.queue_free()

	var s = null
	if perload_scene_map.get(path):
		s = perload_scene_map[path]
	else:
		s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	return current_scene
	
func _action_goto_scene(path):
	last_scene = current_scene

	var s = null
	if perload_scene_map.get(path):
		s = perload_scene_map[path]
	else:
		s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	bSlipAction = true
	nStartSlipTime = OS.get_ticks_msec()
	lastSceneposi = last_scene.rect_position
	curSceneposi = current_scene.rect_position
	current_scene.rect_position = Vector2(current_scene.rect_position.x, current_scene.rect_position.y + sceneH)
	set_process(true)
	return current_scene


# 更改当前场景
func changeScene(tscnPath):
	return _deferred_goto_scene(tscnPath)
#	call_deferred("_deferred_goto_scene", tscnPath)

# 更改当前场景，使用上下切换的动画
func goDownScene(tscnPath):
	return _action_goto_scene(tscnPath)

# 加载场景
func preloadScene(tscnPath):
	var s = ResourceLoader.load(tscnPath)
	perload_scene_map[tscnPath] = s
	
# 后台加载
func runSceneInteractive(tscnPath): 
	loader = ResourceLoader.load_interactive(tscnPath)
	if loader == null:
		return
	set_process(true)

	current_scene.queue_free() 
	wait_frames = 1

func showPanel(tscnPath):
	return _loadPanel(tscnPath)

