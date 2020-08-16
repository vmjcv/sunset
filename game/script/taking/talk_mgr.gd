extends Node

#signal finish_talk

var talkingList = null
#当前在播放的下标
var nowIdx = 0 

var curNode = null

var panel

func _ready():
	#talk([[0, "123213213"], [1, "duqwhufod21d12d21d21d21de"]])
	pass # Replace with function body.

func  _enter_tree():
#	talk([[0, "123213213"], [1, "duqwhufode"]])
	pass # Replace with function body.

func _sayOneLine():
	if len(talkingList) > 0:
		var oneTalkingItem = talkingList.pop_front()
		if panel:
			pass
		else:
			if typeof(curNode) == TYPE_INT:
				panel = load('res://scene/talking/talking.tscn').instance()
				get_tree().get_root().add_child(panel)
			else:
				panel = SceneMgr.showPanel('res://scene/talking/talking.tscn')
			panel.get_node("AnimationPlayer").play("up")
		panel.connect("finish_one_talk", self, "_sayOneLine")
		panel.talk(oneTalkingItem[0], oneTalkingItem[1])
	else:
		talkingList = null
		
		panel.get_node("AnimationPlayer").play("down")
		
		if typeof(curNode) != TYPE_INT:
			curNode.emit_signal("finish_talk")
		curNode = null


# lTalkingList = [[iTalker, sValue]]
func talk(node, lTalkingList):
	talkingList = lTalkingList
	curNode = node
	_sayOneLine()
