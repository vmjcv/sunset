extends TextureRect

signal finish_talk

# node
var nodeFlower = null
var nodeAward = null
var nodePic = null
var nodeRing = null
var nodeMom = null
var nodeDaughter = null
var nodeAnt = null
var nodeDilie = null

var nowCGZhoumu = 0
var nowCGLevel = 0
var bCGing = false

var CG1z5lCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	nodeFlower = get_node("flower")
	nodeAward = get_node("award")
	nodePic = get_node("picture")
	nodeRing = get_node("ring")
	nodeMom = get_node("mom")
	nodeDaughter = get_node("daughter")
	nodeAnt = get_node("ant")
	nodeDilie = get_node("dilie")

func _input(event):
	if not bCGing:
		return
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if CG1z5lCount == 1:
				nodeDaughter.hideNodes()
				nodeDilie.showStatus2()
				nodeAnt.showStatus2()
				CG1z5lCount = 2
				return
				
			if CG1z5lCount == 2:
				GlobalStatusMgr.goToLevel(5)
				CG1z5lCount = 0
				return
				
			if nowCGZhoumu == 1 and ( nowCGLevel == 2):
				nodeDaughter.hideNodes()
				updateStatus()
				get_node("maskTouch").hide()
				bCGing = false
			elif nowCGZhoumu == 1 and(nowCGLevel == 3 or nowCGLevel == 4):
				var dLevel = GlobalStatusMgr.getCurZhoumuLevel()
				if dLevel[3] and dLevel[4]:
#					CG及对话
					nodeDilie.showStatus1()
					CG1z5lCount = 1
				else:
					nodeDaughter.hideNodes()
					updateStatus()
					get_node("maskTouch").hide()
					bCGing = false
			elif nowCGZhoumu == 1 and nowCGLevel == 5:
				SceneMgr.changeScene("res://scene/cg/VideoCg3.tscn")
				
func updateStatus():
	for nodes in [nodeAward, nodeFlower, nodePic, nodeRing, nodeMom, nodeDaughter, nodeDilie, nodeAnt]:
		nodes.updateStatus(GlobalStatusMgr.getCurZhoumu(), GlobalStatusMgr.getCurZhoumuLevel())

func finishLevel(iZhoumu, iLevel):
	nowCGZhoumu = iZhoumu
	nowCGLevel = iLevel
	if iZhoumu == 1:
		if iLevel == 1:
			for nodes in [nodeAward, nodeFlower, nodeMom,]:
				nodes.updateStatus(GlobalStatusMgr.getCurZhoumu(), GlobalStatusMgr.getCurZhoumuLevel())
			nodeDaughter.showGift('award')
			CG1to1()
		elif iLevel == 2:
			for nodes in [nodeAward, nodeFlower, nodeMom,]:
				nodes.updateStatus(GlobalStatusMgr.getCurZhoumu(), GlobalStatusMgr.getCurZhoumuLevel())
			nodeDaughter.showGift('flower')
		elif iLevel == 3:
			for nodes in [nodeAward, nodeFlower, nodeMom, nodePic, nodeRing]:
				nodes.updateStatus(GlobalStatusMgr.getCurZhoumu(), GlobalStatusMgr.getCurZhoumuLevel())
			nodeDaughter.showGift('picture')
		elif iLevel == 4:
			for nodes in [nodeAward, nodeFlower, nodeMom, nodePic, nodeRing]:
				nodes.updateStatus(GlobalStatusMgr.getCurZhoumu(), GlobalStatusMgr.getCurZhoumuLevel())
			nodeDaughter.showGift('rings')
		elif iLevel == 5:
			updateStatus()
		get_node("maskTouch").show()
		bCGing = true

func _do_talk1():
	print(345345)
	nodeDaughter.hideNodes()
	updateStatus()
	get_node("maskTouch").hide()
	bCGing = false

func CG1to1():
	print(123123123)
	connect("finish_talk", self, "_do_talk1")
	TalkMgr.talk(self, [
		[0, "妈妈！你快看，我有这么多奖状和证书耶！"],])
		
#		[1, "... ..."],
#		[1, "... 噢...囡囡真是令妈妈骄傲..."],
#		[0, "... ..."],
#	])
