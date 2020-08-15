extends Node2D


onready var bg = $bg

func _ready():
	pass # Replace with function body.


func play_bg(music_name):
	var path=get_music_path(music_name)
	bg.stream=load(path)
	bg.play()
	
func get_music_path(music_name):
	var path
	match music_name:
		"菜单":
			path ="res://sounds/C0 菜单音乐，纯钢琴.ogg"
		"1-1":
			path="res://sounds/C1-1 一周目，舒缓，八音盒.ogg"
		"1-2":
			path="res://sounds/C1-2 一周目解密音乐，带困惑，笛子，桑巴爵士.ogg"
		"1-3":
			path ="res://sounds/C1-3 诡异氛围音.ogg"
		"2-1":
			path="res://sounds/C2-1 一周目or二周目，阴森，悲怆，木吉他，白噪音.ogg"
		"2-2":
			path="res://sounds/C2-2 二周目，悲伤基调，纯木吉他.ogg"
		"2-3":
			path ="res://sounds/C2-3 一or二，悲伤基调，八音盒.ogg"
		"3-1":
			path="res://sounds/C3-2 三周目关卡部分，激昂，紧张.ogg"
		"3-2":
			path="res://sounds/C3-3 结局+ed 木吉他 钢琴.ogg"
	return path

func play_sound(sound_name):
	var path=get_sound_path(sound_name)
	
	var player = AudioStreamPlayer2D.new()
	add_child(player)
	player.stream=load(path)
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
