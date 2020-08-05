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

- **MoveDirection**   移动方向
-- **DOWN**:30
-- **LEFT**:31
-- **RIGHT**:32
# const

- **MOVE_SPEED**: 50.0    移动速度常量
# export

- **move_time**: 50.0    移动时间，编辑器中可用变量
# var

- **player_node**
# onready

- **score**: 0    总分数
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
