extends Area2D

export var number = 0
export var use_number = 0
export var all_number = 0


func _ready():
	connect("area_entered",ItemManage,"area_entered",[self])
	connect("area_exited",ItemManage,"area_exited",[self])
	connect("mouse_entered",ItemManage,"mouse_entered",[self])
	connect("mouse_exited",ItemManage,"mouse_exited",[self])
