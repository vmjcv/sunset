extends Area2D


onready var scene_item = get_parent()


func _ready():
	connect("mouse_entered",PlotInputManage,"mouse_entered",[scene_item])
	connect("mouse_exited",PlotInputManage,"mouse_exited",[scene_item])

