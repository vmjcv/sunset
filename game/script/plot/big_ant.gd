extends PlotItem

enum status {STATUS_1=1, STATUS_2}

onready var obj_dict={
	status.STATUS_2:$big_ant, # 在右边看的状态
}


func _ready():
	_init_status()
	pass 

func _init_status():
	now_status = status.STATUS_2
	obj_dict[status.STATUS_2].modulate.a = 1
	obj_dict[status.STATUS_2].show()


func change():
	var change_name = "%s_%s"%[now_status,next_status]
	match change_name:
		_:
			pass

