extends Node
class_name PlotItem

signal fade_finish

var now_status 
var next_status

var fade_time = 0.2

# STATUS_1：不显示状态
# STATUS_2：显示烟雾
# STATUS_3：改变前的状态
# STATUS_4：改变后的状态



func _ready():
	pass 
	

func _fade_finish():
	self.now_status = self.next_status
	self.next_status = null
	emit_signal("fade_finish",self)

func can_click():
	if now_status == 3:
		return true
	return false

func click():
	pass
