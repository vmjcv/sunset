extends Node

const maxLevelEachZhoumu = 5

var curLevel = 0

var levelFinsihList = {1:false, 2:false, 3:false, 4:false, 5:false}
var zhoumu = 1

func _ready():
	pass
	
func _matchResult(bSuc):
	if bSuc:
		onLevelFinish()
	else:
		SceneMgr.changeScene('res://scene/start/room.tscn')

func onLevelFinish():
	levelFinsihList[curLevel] = true
	var winCount = 0
	for bWin in levelFinsihList.values():
		if bWin:
			winCount += 1
	if winCount == maxLevelEachZhoumu:
		SceneMgr.changeScene('res://scene/zhoumu_cg/zhoumu'+ zhoumu +'.tscn')
		zhoumu += 1
		levelFinsihList = {1:false, 2:false, 3:false, 4:false, 5:false}
	else:
		var s = SceneMgr.changeScene('res://scene/juqing/1/juqing1.tscn')
		s.finishLevel(zhoumu, curLevel)
	
func getCurLevel():
	return curLevel
	
func getCurZhoumu():
	return zhoumu
	
func getCurZhoumuLevel():
	return levelFinsihList

func isLevelFinish(iLevel):
	return levelFinsihList[iLevel]

# 去小关卡
func goToLevel(number):
	curLevel = number
	#TODO 跳转关卡
	print("jump to " + str(number))
	_matchResult(true)
#	var scene = SceneMgr.changeScene('res://scene/level/level_manager.tscn')
#	scene.set_map_id(curLevel, zhoumu)
#	scene.connect("match_result", self, "_matchResult")
	

