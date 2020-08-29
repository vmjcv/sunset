extends PlotItem

enum status {STATUS_1=1, STATUS_2, STATUS_3,STATUS_4}

onready var obj_dict={
	status.STATUS_2:$smoke, # 烟雾场景
	status.STATUS_3:$picture_2, # 相框改变前
	status.STATUS_4:$picture_3, # 相框改变后
}





func _ready():
	_init_status()
	pass 

func _init_status():
	now_status = status.STATUS_2
	obj_dict[status.STATUS_2].modulate.a = 1
	obj_dict[status.STATUS_3].modulate.a = 1
	obj_dict[status.STATUS_4].modulate.a = 0 

	obj_dict[status.STATUS_2].show()
	obj_dict[status.STATUS_3].show()
	obj_dict[status.STATUS_4].show()


func change():
	var change_name = "%s_%s"%[now_status,next_status]
	match change_name:
		"2_3":
			Fade.fade_out(obj_dict[now_status], fade_time,funcref(self, "_fade_finish"))
		"3_4":
			Fade.fade_out(obj_dict[now_status], fade_time)
			Fade.fade_in(obj_dict[next_status], fade_time,funcref(self, "_fade_finish"))
			
func click():
	if can_click():
		PlotBG.connect("change_over",self,"plot_change_over")
		PlotBG.go_state(6)
		return true
	return false
	
func plot_change_over():
	PlotBG.disconnect("change_over",self,"plot_change_over")

func is_change():
	return now_status == status.STATUS_4
