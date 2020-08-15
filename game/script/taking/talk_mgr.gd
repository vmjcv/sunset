extends Node

var talkingList = null
#当前在播放的下标
var nowIdx = 0 

var panel

func _ready():
	#talk([[0, "123213213"], [1, "duqwhufod21d12d21d21d21de"]])
	pass # Replace with function body.

func  _enter_tree():
#	talk([[0, "123213213"], [1, "duqwhufode"]])
	pass # Replace with function body.

func _sayOneLine():
	print(talkingList)
	if len(talkingList) > 0:
		var oneTalkingItem = talkingList.pop_front()
		if panel:
			pass
		else:
			panel = SceneMgr.showPanel('res://scene/talking/talking.tscn')
			panel.get_node("AnimationPlayer").play("up")
		panel.connect("finish_one_talk", self, "_sayOneLine")
		panel.talk(oneTalkingItem[0], oneTalkingItem[1])
	else:
		talkingList = null
		
		panel.get_node("AnimationPlayer").play("down")
		
		emit_signal("finish_talk")


# lTalkingList = [[iTalker, sValue]]
func talk(lTalkingList):
	talkingList = lTalkingList
	_sayOneLine()
	print("111111111111")
