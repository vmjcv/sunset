extends Node

var level = 0
var zhoumu = 0

func _ready():
	pass
	
func getLevel():
	return level
	
func getZhoumu():
	return zhoumu

# 去小关卡
func goToLevel(number):
	level = number
