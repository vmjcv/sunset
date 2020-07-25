<span style="float:right;">[[source]](https://github.com/vmjcv/sunset/tree/develop/game/script\scene1\Node2D.gd)</span>

# TestChild

 docstring
 代码规范示例


## is_tool

# parent

## Node2D

# signal

- **door_opened**   门打开的时候发出信号
# enum

- **MoveDirection**   枚举
-- **DOWN**:30
-- **LEFT**:31
-- **RIGHT**:32
- **MoveDirection2**
-- **UP**:4
-- **DOWN**:30
-- **LEFT**:31
-- **RIGHT**:32
- **MoveDirection3**
-- **UP**:5
-- **DOWN**:30
-- **LEFT**:31
-- **RIGHT**:32
# const

- **MOVE_SPEED**: 50.0   test
- **MOVE_SPEED_1**: 50.0
# export

- **move_color**: 50.0    导出变量
- **move_color_2**: 50.0
# var

- **my_node2D**
- **my_int**
# onready

- **good**:10
# func

<span style="float:right;">[[source]](https://github.com/vmjcv/sunset/tree/develop/game/script\scene1\Node2D.gd#L12)</span>

## to_api

```python
to_api(a=0,b=0)
```

公开方法使用蛇形命名法,通过静态类型指定传入参数和传出参数

**Argument**
- **a**:0  向量方向
- **b**:0  向量大小
**Return**
- 向量归一化值
