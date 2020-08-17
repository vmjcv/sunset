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
			path="res://texture/item/grass_ring.png"
		"负面情绪":
			path="res://texture/item/negative_emotion.png"
		"花":
			path="res://texture/item/flower.png"
		"奖状":
			path = "res://texture/item/certificate.png"
		"干燥剂":
			path = "res://texture/item/desiccant.png"
		"纸":
			path="res://texture/item/paper.png"
		"花束":
			path="res://texture/item/bouquet.png"
		"花束更新":
			path="res://texture/item/bouquet_update.png"
		"花照片":
			path="res://texture/item/flower_photo.png"
		"蚂蚁":
			path="res://texture/item/ant.png"
		"通知书":
			path="res://texture/item/notice.png"
		"钢笔":
			path="res://texture/item/pen.png"
		"钻戒":
			path="res://texture/item/diamond_ring.png"
		"家规":
			path="res://texture/item/house_rules.png"
		"结婚照":
			path="res://texture/item/wedding_photo.png"
		"奇怪的门":
			path="res://texture/item/纸.png"
	
	texture=load(path)
	
func play_animation():
	get_node("AnimationPlayer").play("get_item")
