extends Node


#by default this checks if the player has said tool in their inventory
@onready var tool = $".."
@onready var inventory = preload("res://_PROTO_/inventroy.tres")

func check():
	return inventory.playerHas(tool.tool_id)
