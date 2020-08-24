extends PlotItem

enum status {STATUS_1=1, STATUS_2, STATUS_3,STATUS_4,STATUS_5}

onready var obj_dict={
	status.STATUS_2:$daughter_3, # 给花
	status.STATUS_3:$daughter_2, # 给戒指
	status.STATUS_4:$daughter_4, # 给奖状
	status.STATUS_5:$daughter_1, # 给照片
}


func _ready():
	_init_status()
	pass 

func _init_status():
	now_status = status.STATUS_1
	obj_dict[status.STATUS_2].modulate.a = 0 
	obj_dict[status.STATUS_3].modulate.a = 0 
	obj_dict[status.STATUS_4].modulate.a = 0 
	obj_dict[status.STATUS_5].modulate.a = 0 
	obj_dict[status.STATUS_2].show()
	obj_dict[status.STATUS_3].show()
	obj_dict[status.STATUS_4].show()
	obj_dict[status.STATUS_5].show()

func change():
	var change_name = "%s_%s"%[now_status,next_status]
	match change_name:
		"1_2","1_3","1_4","1_5":
			Fade.fade_in(obj_dict[next_status], fade_time,funcref(self, "_fade_finish"))
		"2_1","3_1","4_1","5_1":
			Fade.fade_out(obj_dict[next_status], fade_time, funcref(self, "_fade_finish"))


