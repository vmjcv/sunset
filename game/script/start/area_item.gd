extends Area2D

export var number = 0

func _ready():
	connect("mouse_entered",AreaItemManage,"mouse_entered",[self])
	connect("mouse_exited",AreaItemManage,"mouse_exited",[self])
