extends PlotItem

enum status {STATUS_1=1, STATUS_2, STATUS_3,STATUS_4}

onready var obj_dict={
	status.STATUS_2:$dilie_1, # 小地裂
	status.STATUS_3:$dilie_2, # 中地裂
	status.STATUS_4:$dilie_3, # 大地裂
}

func _ready():
	_init_status()
	pass 

func _init_status():
	now_status = status.STATUS_2
	obj_dict[status.STATUS_2].modulate.a = 1
	obj_dict[status.STATUS_3].modulate.a = 0 
	obj_dict[status.STATUS_4].modulate.a = 0 

	obj_dict[status.STATUS_2].show()
	obj_dict[status.STATUS_3].show()
	obj_dict[status.STATUS_4].show()


func change():
	var change_name = "%s_%s"%[now_status,next_status]
	match change_name:
		"2_3","3_4":
			Fade.fade_out(obj_dict[now_status], fade_time)
			Fade.fade_in(obj_dict[next_status], fade_time,funcref(self, "_fade_finish"))


