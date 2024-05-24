extends ToolAdditionalAction

#by default this will remove 1 from its quantity in inventory
@onready var inventory = preload("res://_PROTO_/inventroy.tres")

func _on_tool_used():
	inventory.consumeItem(tool.tool_id)
