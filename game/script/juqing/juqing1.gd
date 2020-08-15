extends TextureRect

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
				GlobalStatusMgr.goToLevel(5)
				CG1z5lCount = 0
				return
				
			if nowCGZhoumu == 1 and (nowCGLevel == 1 or nowCGLevel == 2):
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
					
				
func updateStatus():
	for nodes in [nodeAward, nodeFlower, nodePic, nodeRing, nodeMom, nodeDaughter, nodeAnt, nodeDilie]:
		nodes.updateStatus(GlobalStatusMgr.getCurZhoumu(), GlobalStatusMgr.getCurZhoumuLevel())

func finishLevel(iZhoumu, iLevel):
	nowCGZhoumu = iZhoumu
	nowCGLevel = iLevel
	if iZhoumu == 1:
		if iLevel == 1:
			for nodes in [nodeAward, nodeFlower, nodeMom,]:
				nodes.updateStatus(GlobalStatusMgr.getCurZhoumu(), GlobalStatusMgr.getCurZhoumuLevel())
			nodeDaughter.showGift('award')
		elif iLevel == 2:
			for nodes in [nodeAward, nodeFlower, nodeMom,]:
				nodes.updateStatus(GlobalStatusMgr.getCurZhoumu(), GlobalStatusMgr.getCurZhoumuLevel())
			nodeDaughter.showGift('flower')
		elif iLevel == 3:
			for nodes in [nodeAward, nodeFlower, nodeMom, ]:
				nodes.updateStatus(GlobalStatusMgr.getCurZhoumu(), GlobalStatusMgr.getCurZhoumuLevel())
			nodeDaughter.showGift('picture')
		elif iLevel == 4:
			for nodes in [nodeAward, nodeFlower, nodeMom, ]:
				nodes.updateStatus(GlobalStatusMgr.getCurZhoumu(), GlobalStatusMgr.getCurZhoumuLevel())
			nodeDaughter.showGift('ring')
		elif iLevel == 5:
			updateStatus()
			return
		get_node("maskTouch").show()
		bCGing = true
