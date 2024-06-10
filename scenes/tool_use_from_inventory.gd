extends ToolAdditionalAction

var tool_id = 3
@onready var inventory = preload("res://_PROTO_/inventroy.tres")

func _on_tool_hit():
	inventory.consumeItem(tool_id)
