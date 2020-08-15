extends Node

const maxLevelEachZhoumu = 5

var level = 1
var zhoumu = 1

func _ready():
	pass

func onLevelFinish():
	if level == maxLevelEachZhoumu:
		SceneMgr.changeScene('res://scene/zhoumu_cg/zhoumu'+ zhoumu +'.tscn')
		zhoumu += 1
		level = 0
	else:
		level += 1
	
func getLevel():
	return level
	
func getZhoumu():
	return zhoumu

# 去小关卡
func goToLevel(number):
	level = number

