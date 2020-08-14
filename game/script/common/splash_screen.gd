extends CenterContainer

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var logo_anim : AnimatedSprite = $Panel/GamejamLogo
onready var studio_anim : AnimatedSprite = $Panel/StudioLogo
signal done

func _ready():
	animation_player.connect("animation_finished", self, "animation_player_finished")
	logo_anim.connect("animation_finished", self, "logo_anim_finished")
	studio_anim.connect("animation_finished", self, "studio_anim_finished")
	animation_player.play("show_godot")
	
func _input(event):
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton:
		if event.pressed and animation_player.is_playing():
			animation_player.seek(max(4.0, animation_player.current_animation_position), true)
		elif event.pressed and logo_anim.is_playing():
			logo_anim.stop()
			logo_anim.emit_signal("animation_finished")
		elif event.pressed and studio_anim.is_playing():
			studio_anim.stop()
			studio_anim.emit_signal("animation_finished")
	get_tree().set_input_as_handled()

func animation_player_finished(anim: String):
	if anim == "show_godot":
		logo_anim.show()
		logo_anim.animation = "show_logo"
		logo_anim.play()

func logo_anim_finished():
	studio_anim.show()
	studio_anim.animation = "show_studio"
	studio_anim.play()
	
func studio_anim_finished():
	print("finished")
	emit_signal("done")
	queue_free()
<<<<<<< HEAD
	#TODO switch to main scene	--醉醉

=======
	#TODO switch to main scene	--醉醉			show_error()
	SceneMgr.changeScene('res://scene/start/main.tscn')
>>>>>>> 8ce8d6e652fb1e8c0df5c0d4ed19bd35713ebd60
