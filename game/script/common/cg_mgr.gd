extends Node

var cg_class = preload("res://scene/cg/cg.tscn")

signal cg_over
var number
func _ready():
	pass 

func show_cg(cg_number):
	var path
	match cg_number:
		0: # 直接发cg结束的信号
			emit_signal("cg_over")
			return
		1: # 开局cg
			path = "res://effect/cg/divorce_agreement.ogv"
		2: # 母亲不好的回忆（电话）
			path = "res://effect/cg/bad_memories.ogv"
		3: # 孩子向母亲发脾气
			path = "res://effect/cg/loose_temper.ogv"
		4: # 妈妈向孩子述说感受
			path = "res://effect/cg/narrate_feelings.ogv"
		5: # 勉强在一起的结局
			path = "res://effect/cg/graduation_photo.ogv"
		6: # 我奔向你结局
			path = "res://effect/cg/season_finale.ogv"
	number = cg_number
	var player = cg_class.instance()
	player.stream =  load(path)
	add_child(player)
	player.play()
	player.connect("finished",self,"remove_one",[player])
	
func remove_one(node):
	node.disconnect("finished",self,"remove_one")
	remove_child(node)
	emit_signal("cg_over")
	if number == 2:
		PlotBG.go_state(11)
	number = null
