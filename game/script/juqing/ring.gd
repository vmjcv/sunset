extends Node2D

const STATUS_CLOSE = 1
const STATUS_OPEN = 2
const STATUS_FINISH = 3

var status = STATUS_CLOSE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func updateStatus(iZhoumu, dLevel):
	if iZhoumu > 1:
		status = STATUS_FINISH
	else:
		if not dLevel[1] or not dLevel[2]:
			status = STATUS_CLOSE
		elif dLevel[4]:
			status = STATUS_FINISH
		else:
			status = STATUS_OPEN
	
	get_node("close").hide()
	get_node("open").hide()
	get_node("finish").hide()
	get_node("jump").hide()
	if status == STATUS_CLOSE:
		get_node("close").show()
	elif status == STATUS_OPEN:
		get_node("open").show()
		get_node("jump").show()
	else:
		get_node("finish").show()



func _on_jump_pressed():
	GlobalStatusMgr.goToLevel(4)
