class_name AreaItemManage
extends Node

# 场景道具管理类

var now_mouse_entered_item	

func mouse_entered(item):
	now_mouse_entered_item = item

func mouse_exited(item):
	if now_mouse_entered_item==item:
		now_mouse_entered_item=null
	pass
	
func mouse_click():
	check_click()
	
func check_click():
	if now_mouse_entered_item:
		var number = now_mouse_entered_item.number
		SceneMgr.go_scene(number)
	

