extends PlotItem

enum status {STATUS_1=1, STATUS_2, STATUS_3,STATUS_4}

onready var obj_dict={
	status.STATUS_2:$smoke, # 烟雾场景
	status.STATUS_3:$huaping_1, # 花瓶改变前
	status.STATUS_4:$huaping_2, # 花瓶改变后
}

func _ready():
	_init_status()
	pass 

func _init_status():
	now_status = status.STATUS_3
	obj_dict[status.STATUS_2].modulate.a = 0
	obj_dict[status.STATUS_3].modulate.a = 1 
	obj_dict[status.STATUS_4].modulate.a = 0 

	obj_dict[status.STATUS_2].show()
	obj_dict[status.STATUS_3].show()
	obj_dict[status.STATUS_4].show()


func change():
	var change_name = "%s_%s"%[now_status,next_status]
	match change_name:
		"3_4":
			Fade.fade_out(obj_dict[now_status], fade_time)
			Fade.fade_in(obj_dict[next_status], fade_time,funcref(self, "_fade_finish"))


func click():
	if can_click():
		
		
		
		return true
	return false
