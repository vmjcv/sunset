extends Node


var curLevel = 0

var levelFinsihList = {1:false, 2:false, 3:false, 4:false, 5:false}
var zhoumu = 1

func _matchResult(item_list,bSuc):
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
#	if winCount == maxLevelEachZhoumu:
#		SceneMgr.changeScene('res://scene/zhoumu_cg/zhoumu'+ zhoumu +'.tscn')
#		zhoumu += 1
#		levelFinsihList = {1:false, 2:false, 3:false, 4:false, 5:false}
#	else:

	var s
	if zhoumu == 1:
		s = SceneMgr.changeSceneFade('res://scene/juqing/1/juqing1.tscn')
	elif zhoumu ==2:
		s = SceneMgr.changeSceneFade('res://scene/juqing/2/juqing2.tscn')
	elif zhoumu ==3:
		s = SceneMgr.changeSceneFade('res://scene/juqing/3/juqing1.tscn')
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
	#print("jump to " + str(number))
#	_matchResult([],true)
	var scene = SceneMgr.changeSceneFade('res://scene/level/level_manager.tscn')
	var panel = scene.get_node("Panel")
	panel.set_map_id(curLevel, zhoumu)
	panel.connect("match_result", self, "_matchResult")
	AudioPlayer.play_bg("%s-%s"%[zhoumu,curLevel])
	
func nextZhoumu():
	zhoumu += 1
	levelFinsihList = {1:false, 2:false, 3:false, 4:false, 5:false}

func get_match_result(item_list,bSuc):
	var scene = SceneMgr.changeScene("res://scene/common/over_item.tscn")
	pass

func is_special_ant(level, zhoumu):
	return false