# 项目启动
## 检出项目工程
建立一个空文件夹，然后将脚本“检出游戏.bat” 放入，运行脚本即可（需要安装git）

## 检出编辑器和打包文件
在相关安装包中阅读README

## 打包脚本
生成安卓包，html包，exe包（windows平台）

## 启动游戏
运行启动exe，启动html，启动编辑器后打开都可以

# 代码规范
## godot引擎类似unity，但是每个节点只能配一个脚本文件，节点类似于场景和类的概念，[https://docs.godotengine.org/zh_CN/latest/getting_started/editor/unity_to_godot.html](https://docs.godotengine.org/zh_CN/latest/getting_started/editor/unity_to_godot.html)
介绍后续再补充
## 存放路径
- 存放路径应该为   “文件类型/所属场景”
例如我有个场景1的怪物场景文件，我就将其放在scene/scene1文件夹中
如果这个怪物场景文件是两个及两个以上场景需要使用的，就将其放在scene/common文件夹中。其他类型文件同理

## 设计规范
- 尽量往自己感觉好的地方设计，基本上是每个人设计一个模块，然后对外提供调用接口，互相之间是不会管对方类里面写了什么，写完某个类就更新一下api文档，会提供一个生成api的脚本，暴露给外界的方法每个类的参数要是固定类型，返回值也要是固定类型，[https://docs.godotengine.org/zh_CN/latest/getting_started/scripting/gdscript/static_typing.html](https://docs.godotengine.org/zh_CN/latest/getting_started/scripting/gdscript/static_typing.html)注释中包含每个参数的意义和返回值的意义

## 命名规范
### 动态语言规范
#### 格式
##### 编码和特殊字符
- 使用换行符（LF）来换行，而不是 CRLF 或 CR。
- 在每个文件的末尾使用一个换行符。
- 使用不带 字节顺序标记（BOM） 的 UTF-8 编码
- 使用 Tabs 代替制表符进行缩进（称为“软制表符”）。
##### 缩进
- 每个缩进级别必须大于包含它的代码块。
- 使用2个缩进级别来区分续行与常规代码块。此规则的例外是数组、字典和枚举。使用单个缩进级别来区分连续行：

##### 尾随逗号
- 尾随逗号在数组、字典和枚举的最后一行使用逗号。
这将使版本控制中的重构更容易，差异也更大，因为添加新元素时不需要修改最后一行。
- 单行列表中不需要尾随逗号，因此在这种情况下不要添加它们。

##### 空白行
- 用两个空行包围函数和类定义：
- 函数内部使用一个空行来分隔逻辑部分。

##### 每行最大字符数
- 把每行代码控制在80个字符以内。
这有助于在小屏幕上阅读代码，并在外部文本编辑器中并排打开两个脚本。例如，在查看差异修订时。
- 一条语句一行，该规则的唯一例外是三元运算符：

##### 避免不必要的圆括号
- 避免表达式和条件语句中的括号。除非对操作顺序有必要，否则它们只会降低可读性。

##### 布尔运算
- 首选布尔运算符的纯英文版本，因为它们是最容易访问的：
    - 使用``and``代替 &&。
    - 使用``or``代替 ||。
- 也可以在布尔运算符周围使用括号来清除任何歧义。这可以使长表达式更容易阅读。

##### 注释间距
- 普通注释开头应该留一个空格，但如果是为了停用代码而将其注释掉则不需要留。这样可以用来区分文本注释和停用的代码。

##### 空格
- 请始终在运算符前后和逗号后使用一个空格。也避免在字典引用和函数调用中使用多余的空格。

##### 引号
- 尽量使用双引号，除非单引号可以让字符串中需要转义的字符变少

#### 命名约定
##### 类与节点
- 对类和节点名称使用帕斯卡命名法（PascalCase）：
`extends KinematicBody`
- 将类加载到常量或变量时同样适用：
`const Weapon = preload("res://weapon.gd")`
##### 函数与变量
- 使用蛇形命名法（snake_case）来命名函数与变量：
```
var particle_effectfunc 
load_level():
```
- 在虚方法（用户必须重写的函数）、私有函数、和私有变量前加一个下划线（_）：
```
var _counter = 0
func _recalculate_path():
```
##### 信号
- 用过去时态来命名信号：
```
signal door_opened
signal score_changed
```
##### 常数和枚举
- 使用 CONSTANT_CASE，全部大写，用下划线（_）分隔单词 ：
`const MAX_SPEED = 200`
- 对枚举*名称*使用PascalCase，对其成员使用CONSTANT_CASE ，因为它们是常量：
```
enum Element {
    EARTH,
    WATER,
    AIR,
    FIRE,
 }
```
#### 代码顺序
```

01. tool
02. class_name
03. extends
04. # docstring

05. signals
06. enums
07. constants
08. exported variables
09. public variables
10. private variables
11. onready variables

12. optional built-in virtual _init method
13. built-in virtual _ready method
14. remaining built-in virtual methods
15. public methods
16. private methods
```

# 资源规范
## 存放路径：
- 存放路径应该为   “文件类型/所属场景”
例如我有个场景1的音乐文件，我就将其放在sounds/scene1文件夹中
如果这个音乐文件是两个及两个以上场景需要播放的，就将其放在sounds/common文件夹中。其他类型文件同理
- effect ： 特效
- fonts： 字体
- scene：场景
- script：脚本
- shader：着色器
- sounds：音乐及音效
- texture：图片及ui

## 命名规范
- 全部用拼音命名即可
- 文字和文字之间就加个__,例如怪物1，即为guai_wu_1,不用管命名多长，不要缩写
- 如果是两个及两个以上的物品即用类别加数字的形式命名，比如我们要做的游戏里面有10个相似的怪物，那么这10个怪物的名字就命名为guai_wu_1,guai_wu_2,以此类推。当然如果只有一个唯一的物体就不用加数字后缀，比如主角。如果有特殊需求的图片也是要加数字后缀的，比如你给了我三个太阳，要随机在地图上显示一种颜色的太阳，那么这个时候太阳的名字最好命名为tai_yang_1,tai_yang_2,tai_yang_3.别命名成红太阳，绿太阳，黄太阳。这样很不好写代码。

## 设计分辨率
- 按1024*768出设计图即可，可以直接搭ui

## 不要做的事情
- 给图片加了一堆花边，然后左边图少了一点光晕，右边图多了一点光晕，导致图片中心不是真正的图片中心，这样子我们摆放位置和做缩放都很困难，可以考虑将左边图补几个空白像素，让图片的中心回到真正的中心点
- psd文件要保存好，别合并后后期效果不好调整
- 遇到失败或者冲突要慎重，就是call我们就行
- 程序不要做的事情，不要随意更换资源文件的命名位置，如果需要更换命名位置，尽量call美术让她自己来，防止出现冲突


