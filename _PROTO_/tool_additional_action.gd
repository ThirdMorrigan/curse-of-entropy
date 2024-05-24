extends Node
class_name ToolAdditionalAction

@onready var tool : ToolAttack = $".."

@export var onUse : bool = false
@export var onHit : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if onHit:
		tool.hit.connect(_on_tool_hit)
	if onUse:
		tool.toolUsed.connect(_on_tool_used)

#should be replace in children
func _on_tool_used():
	print("this tool has no implimitaion on use")

func _on_tool_hit():
	print("this tool has no implimitaion on hit")
