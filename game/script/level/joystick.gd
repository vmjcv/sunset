extends Sprite

var maxLen = 60
var threshold = 30
var onDraging = -1
var tween

onready var map = get_parent().get_parent().get_node("Panel")

func _ready():
	tween = Tween.new()
	add_child(tween)
	tween.connect("tween_all_completed",self,"tween_all_completed")

func _input(event):
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		var mouse_pos = (event.position - self.global_position).length()
		if mouse_pos <= maxLen or event.get_index() == onDraging:
			onDraging = event.get_index()
			$point.set_global_position(event.position)
			if get_point_pos().length() > maxLen:
				$point.set_position(get_point_pos().normalized()*maxLen)
	if event is InputEventScreenTouch and !event.is_pressed():
		if event.get_index() == onDraging:
			set_center()
			onDraging = -1
			var pos = get_point_pos()
			if pos.length() > threshold:
				if abs(pos.x) > abs(pos.y):
					if pos.x < 0:
						map.my_input("ui_left")
					else:
						map.my_input("ui_right")
				else:
					if pos.y < 0:
						map.my_input("ui_up")
					else:
						map.my_input("ui_down")
		
			
func get_point_pos():
	return $point.position

func set_center():
	tween.interpolate_property($point, "position", get_point_pos(), Vector2(0,0), 0.1, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	tween.start()
	


