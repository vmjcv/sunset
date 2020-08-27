extends PlotItem

enum status {STATUS_1=1, STATUS_2, STATUS_3,STATUS_4}

onready var obj_dict={
	status.STATUS_2:$smoke, # 显示烟雾
	status.STATUS_3:$award_empty, # 显示修复前的奖状
	status.STATUS_4:$award_color, # 显示修复后的奖状
}

func _ready():
	_init_status()
	pass 

func _init_status():
	now_status = status.STATUS_3
	obj_dict[status.STATUS_2].modulate.a = 0 
	obj_dict[status.STATUS_3].modulate.a = 0 
	obj_dict[status.STATUS_4].modulate.a = 0 

	obj_dict[status.STATUS_2].show()
	obj_dict[status.STATUS_3].show()
	obj_dict[status.STATUS_4].show()
	

func change():
	var change_name = "%s_%s"%[now_status,next_status]
	match change_name:
		"1_2":
			Fade.fade_in(obj_dict[status.STATUS_2], fade_time)
			Fade.fade_in(obj_dict[status.STATUS_3], fade_time, funcref(self, "_fade_finish"))
		"1_3":
			_fade_finish()
			# Fade.fade_in(obj_dict[status.STATUS_3], fade_time)
			# Fade.fade_in(obj_dict[status.STATUS_4], fade_time, funcref(self, "_fade_finish"))
		"2_3":
			Fade.fade_out(obj_dict[status.STATUS_2], fade_time, funcref(self, "_fade_finish"))
		"3_4":
			Fade.fade_in(obj_dict[status.STATUS_3], fade_time)
			Fade.fade_in(obj_dict[status.STATUS_4], fade_time, funcref(self, "_fade_finish"))
		"1_4":
			Fade.fade_in(obj_dict[status.STATUS_3], fade_time)
			Fade.fade_in(obj_dict[status.STATUS_4], fade_time, funcref(self, "_fade_finish"))

func click():
	if can_click():
		PlotBG.connect("change_over",self,"plot_change_over")
		PlotBG.go_state(3)
		return true
	return false
	
func plot_change_over():
	PlotBG.disconnect("change_over",self,"plot_change_over")

