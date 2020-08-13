tool
extends EventChainNode

# 显示所有的数据类型


func _init() -> void:
	unique_id = "debug_color_palette"
	display_name = "Palette"
	category = "Debug"
	description = "在一个控件中显示所有的数据类型"

	set_input(0, "Any", EventChainGraphDataType.ANY)
	set_input(1, "Boolean", EventChainGraphDataType.BOOLEAN)
	set_input(2, "Scalar", EventChainGraphDataType.SCALAR)
	set_input(3, "String", EventChainGraphDataType.STRING)
