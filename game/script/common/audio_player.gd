extends AudioStreamPlayer

var music_array
var music_dict

var sound_array
var sound_dict

func _ready():
	music_array = _get_music_table()
	music_dict = _array_to_dict(music_array)
	
	sound_array = _get_sound_table()
	sound_dict = _array_to_dict(sound_array)

func _get_music_table():
	return Configs.get_table_configs(Configs.music_infoData)

func _get_sound_table():
	return Configs.get_table_configs(Configs.sound_infoData)

func _array_to_dict(ogg_array):
	var dict={}
	for obj in ogg_array:
		dict[obj.name] = obj
	return dict
	

	
func get_music_path(music_name):
	return music_dict[music_name].path

func get_sound_path(sound_name):
	return sound_dict[sound_name].path


func play_bg(music_name):
	self.stream=load(get_music_path(music_name))
	self.play()
	
func stop_bg():
	self.stop()

func play_sound(sound_name):
	var node=get_sound_path(sound_name)
	var player = AudioStreamPlayer2D.new()
	add_child(player)
	player.stream=node
	player.play()
	player.connect("finished",self,"remove_one",[player])
	
func remove_one(node):
	remove_child(node)
	

