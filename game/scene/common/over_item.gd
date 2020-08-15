extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_img(item_name):
	var path
	match item_name:
		"草戒指":
			path="res://texture/item/草戒指.png"
		"负面情绪":
			path="res://texture/item/负面情绪.png"
		"花":
			path="res://texture/item/花.png"
		"奖状":
			path = "res://texture/item/奖状.png"
		"干燥剂":
			path = "res://texture/item/干燥剂.png"
		"纸":
			path="res://texture/item/纸.png"
		"花束":
			path="res://texture/item/花束.png"
		"花束更新":
			path="res://texture/item/花束更新.png"
		"花照片":
			path="res://texture/item/花照片.png"
		"蚂蚁":
			path="res://texture/item/蚂蚁.png"
		"通知书":
			path="res://texture/item/通知书.png"
		"钢笔":
			path="res://texture/item/钢笔.png"
		"钻戒":
			path="res://texture/item/钻戒.png"
		"家规":
			path="res://texture/item/家规.png"
		"结婚照":
			path="res://texture/item/结婚照.png"
	
	texture=load(path)
	
func play_animation():
	get_node("AnimationPlayer").play("get_item")
