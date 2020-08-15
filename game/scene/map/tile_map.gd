extends TileMap

var dict={}

func _ready():
	for obj in get_children():
		dict[obj.x*100+obj.y]=obj
	

