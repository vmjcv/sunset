extends TextureRect

# node
var nodeFlower = null
var nodeAward = null
var nodePic = null
var nodeRing = null
var nodeMom = null
var nodeDaughter = null

var nowCGZhoumu = 0
var nowCGLevel = 0
var bCGing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	nodeFlower = get_node("flower")
	nodeAward = get_node("award")
	nodePic = get_node("picture")
	nodeRing = get_node("ring")
	nodeMom = get_node("mom")
	nodeDaughter = get_node("daughter")

func _input(event):
	if not bCGing:
		return
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if nowCGZhoumu == 1 and (nowCGLevel == 1 or nowCGLevel == 2):
				nodeDaughter.hideNodes()
				updateStatus()
			elif nowCGZhoumu == 1 and nowCGLevel == 3:
				pass
			elif nowCGZhoumu == 1 and nowCGLevel == 4:
				pass
			get_node("maskTouch").hide()
				
func updateStatus():
	for nodes in [nodeAward, nodeFlower, nodePic, nodeRing, nodeMom, nodeDaughter]:
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
		get_node("maskTouch").show()
		bCGing = true
