extends CenterContainer

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var frame_anim : AnimatedSprite = $Panel/GamejamLogo
signal done

func _ready():
	animation_player.connect("animation_finished", self, "animation_player_finished")
	frame_anim.connect("animation_finished", self, "frame_anim_finished")
	animation_player.play("show_godot")
	
func _input(event):
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton:
		if event.pressed and animation_player.is_playing():
			animation_player.seek(max(4.0, animation_player.current_animation_position), true)
		elif event.pressed and frame_anim.is_playing():
			frame_anim.stop()
			frame_anim.emit_signal("animation_finished")
	get_tree().set_input_as_handled()

func animation_player_finished(anim: String):
	if anim == "show_godot":
		frame_anim.show()
		frame_anim.animation = "show_logo"
		frame_anim.play()
	elif anim == "show_studio":
		print("finished")
		emit_signal("done")
		queue_free()
		#TODO switch to main scene	--醉醉

func frame_anim_finished():
	animation_player.play("show_studio")
	frame_anim.hide()
