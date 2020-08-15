extends Node2D

const STATUS_OPEN = 1
const STATUS_CLOSE = 2

var status = STATUS_CLOSE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func updateStatus(iZhoumu, dLevel):
	if iZhoumu > 1:
		status = STATUS_CLOSE
	else:
		if dLevel[1]:
			status = STATUS_CLOSE
		else:
			status = STATUS_OPEN
	
	if status == STATUS_CLOSE:
		get_node("chouti").hide()
		get_node("finish").show()
	else:
		get_node("finish").hide()
		get_node("chouti").show()
		
func _on_chouti_pressed():
	GlobalStatusMgr.goToLevel(1)
