extends TileMap

var dict={}

func _ready():
	for obj in get_children():
		var index = obj.x*100+obj.y
		dict[String(index)]=obj
	

