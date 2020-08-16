extends AudioStreamPlayer

func _ready():
	pass
	
func play_bg(music_name):
	self.stream=load(get_music_path(music_name))
	self.play()
	
func get_music_path(music_name):
	var node
	match music_name:
		"菜单":
			node ="res://sounds/C0-0.ogg"
		"1-1":
			node ="res://sounds/C1-1 一周目，舒缓，八音盒.ogg"
		"1-2":
			node ="res://sounds/C1-2 一周目解密音乐，带困惑，笛子，桑巴爵士.ogg"
		"1-3":
			node ="res://sounds/C1-2 一周目解密音乐，带困惑，笛子，桑巴爵士.ogg"
		"1-4":
			node ="res://sounds/C1-2 一周目解密音乐，带困惑，笛子，桑巴爵士.ogg"
		"1-5":
			node ="res://sounds/C1-3 诡异氛围音.ogg"
		"2-1":
			node ="res://sounds/C2-1 一周目or二周目，阴森，悲怆，木吉他，白噪音.ogg"
		"2-2":
			node ="res://sounds/C2-2 二周目，悲伤基调，纯木吉他.ogg"
		"2-3":
			node ="res://sounds/C2-2 二周目，悲伤基调，纯木吉他.ogg"
		"2-4":
			node ="res://sounds/C2-2 二周目，悲伤基调，纯木吉他.ogg"
		"2-5":
			node ="res://sounds/C2-3 一or二，悲伤基调，八音盒.ogg"
		"3-1":
			node ="res://sounds/C3-2 三周目关卡部分，激昂，紧张.ogg"
		"3-2":
			node ="res://sounds/C3-3 结局+ed 木吉他 钢琴.ogg"
		"3-3":
			node ="res://sounds/C3-3 结局+ed 木吉他 钢琴.ogg"
		"3-4":
			node ="res://sounds/C3-3 结局+ed 木吉他 钢琴.ogg"
		"3-5":
			node ="res://sounds/C3-3 结局+ed 木吉他 钢琴.ogg"
	return node

func play_sound(sound_name):
	var node=get_sound_path(sound_name)
	
	var player = AudioStreamPlayer2D.new()
	add_child(player)
	player.stream=node
	player.play()
	player.connect("finished",self,"remove_one",[player])
	
func remove_one(node):
	remove_child(node)
	
func get_sound_path(sound_name):
	var path
	match sound_name:
		"":
			path="res://sounds/C3-3 结局+ed 木吉他 钢琴.ogg"
	return path
