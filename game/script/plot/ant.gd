extends PlotItem

enum status {STATUS_1=1, STATUS_2, STATUS_3}

onready var obj_dict={
	status.STATUS_1:$ant_1,
	status.STATUS_2:$ant_2,
	status.STATUS_3:$ant_3,
}


func _ready():
	_init_status()
	pass 

func _init_status():
	now_status = status.STATUS_1
	obj_dict[status.STATUS_1].modulate.a = 1
	obj_dict[status.STATUS_2].modulate.a = 0 
	obj_dict[status.STATUS_3].modulate.a = 0 

	obj_dict[status.STATUS_1].show()
	obj_dict[status.STATUS_2].show()
	obj_dict[status.STATUS_3].show()


func change():
	var change_name = "%s_%s"%[now_status,next_status]
	match change_name:
		_:
			Fade.fade_in(obj_dict[next_status], fade_time, funcref(self, "_fade_finish"))
			Fade.fade_out(obj_dict[now_status], fade_time)
			# 所有的状态转换的默认处理
			pass

