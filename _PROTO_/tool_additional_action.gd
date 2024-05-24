extends Node
class_name ToolAdditionalAction

@onready var tool = $".."
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#should be replace in children
func _on_tool_used():
	print("this tool has no implimitaion")
