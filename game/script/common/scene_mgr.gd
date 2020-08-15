extends Node

var current_scene = null

#预加载场景
var perload_scene_map = {}

# 后台加载
var loader
var wait_frames
var time_max = 100 # msec

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func _process(time):
	if loader == null:
		set_process(false)
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

func _deferred_goto_scene(path):
	current_scene.free()

	var s = null
	if perload_scene_map.get(path):
		s = perload_scene_map[path]
	else:
		s = ResourceLoader.load(path)
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	
# 更改当前场景
func changeScene(path):
	call_deferred("_deferred_goto_scene", path)

# 加载场景
func preloadScene(tscnPath):
	var s = ResourceLoader.load(tscnPath)
	perload_scene_map[tscnPath] = s
	
	
func runSceneInteractive(path): 
	loader = ResourceLoader.load_interactive(path)
	if loader == null:
		return
	set_process(true)

	current_scene.queue_free() 
	wait_frames = 1

func go_scene(number):
	# 去小关卡
	pass
