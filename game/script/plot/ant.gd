extends PlotItem

enum status {STATUS_1=1, STATUS_2,STATUS_3}

onready var obj_dict={
	status.STATUS_1:$ant_1,
	status.STATUS_2:$ant_2,
}


func _ready():
	_init_status()
	pass 

func _init_status():
	now_status = status.STATUS_1
	obj_dict[status.STATUS_1].modulate.a = 1
	obj_dict[status.STATUS_2].modulate.a = 0 

	obj_dict[status.STATUS_1].show()
	obj_dict[status.STATUS_2].show()



func change():
	var change_name = "%s_%s"%[now_status,next_status]
	match change_name:
		"1_2":
			Fade.fade_in(obj_dict[status.STATUS_2], fade_time, funcref(self, "_fade_finish"))
		"2_3":
			_fade_finish()
		_:
			Fade.fade_in(obj_dict[next_status], fade_time, funcref(self, "_fade_finish"))
			Fade.fade_out(obj_dict[now_status], fade_time)
			# 所有的状态转换的默认处理
			pass

func can_click():
	if now_status == status.STATUS_2:
		return true
	return false

func click():
	if can_click():
		PlotBG.connect("change_over",self,"plot_change_over")
		PlotBG.go_state(11)
		return true
	return false
	
func plot_change_over():
	PlotBG.disconnect("change_over",self,"plot_change_over")
	# 跳第一周目结尾cg
	#GlobalStatusMgr.goToLevel(2)
