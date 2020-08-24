extends Area2D

export var number = 0
export var use_number = 0
export var all_number = 0


onready var scene_item = get_parent()


func _ready():
	connect("mouse_entered",PlotInputManage,"mouse_entered",[scene_item])
	connect("mouse_exited",PlotInputManage,"mouse_exited",[scene_item])


