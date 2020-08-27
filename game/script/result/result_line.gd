extends HBoxContainer


func _ready():
	pass
	
func set_label(item_name,number=0):
	var label = get_node("result_label")
	label.id = "result_label"+String(number)
	label.bbcode_text = "[bounce id=result_label"+String(number)+"]"+item_name+"[/bounce]"
	

func show():
	var label = get_node("result_label")
	label.fade_in()
