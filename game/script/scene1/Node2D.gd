tool
extends Node2D
class_name TestChild


# docstring
# 代码规范示例

signal door_opened # 门打开的时候发出信号
enum MoveDirection {UP, DOWN=30, LEFT, RIGHT} # 枚举
enum MoveDirection2 {UP=4, DOWN=30, LEFT, RIGHT} 
enum MoveDirection3 {UP=5, DOWN=30, LEFT, RIGHT} 
const MOVE_SPEED: float = 50.0 #test
const MOVE_SPEED_1: float = 50.0
export var move_color: float = 50.0 # 导出变量
export var move_color_2: float = 50.0
var my_node2D: Node2D
var my_int: int
var _self_help: String
onready var good =10

func _init():
	pass


func _ready():
	pass


func _enter_tree():
	pass


func _exit_tree():
	pass


func _process(delta):
	pass


func _physics_process(delta):
	pass


func _input(event):
	pass


func _unhandled_input(event):
	pass


func _draw():
	pass

func to_api(a: int,b: int)-> int:
	# @:公开方法使用蛇形命名法,通过静态类型指定传入参数和传出参数
	# @a:向量方向
	# @b:向量大小
	# @return:向量归一化值
	var value = a+b
	return value

func _not_to_api(a: int,b: int)-> int:
	# 私有方法不会生成到api文档中
	var value = a+b
	return value
