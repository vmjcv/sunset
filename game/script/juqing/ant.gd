extends Node2D


const STATUS_1 = 1
const STATUS_2 = 2
const STATUS_3 = 3

var status = STATUS_1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _reset():
	if not get_node("statu1"):
		return
	get_node("statu1").hide()
	get_node("statu2").hide()
	get_node("statu3").hide()

func updateStatus(iZhoumu, dLevel):
	if iZhoumu > 1:
		status = STATUS_3
	else:
		if dLevel[3] and dLevel[4]:
			status = STATUS_2
		elif dLevel[5]:
			status = STATUS_3
		else:
			status = STATUS_1
	
	_reset()
	if not get_node("statu1"):
		return
	if status == STATUS_1:
		get_node("statu1").show()
	elif status == STATUS_2:
		get_node("statu2").show()
	elif status == STATUS_3:
		get_node("statu3").show()

func showStatus2():
	_reset()
	get_node("statu2").show()
	

func showStatus3():
	_reset()
	get_node("statu3").show()
