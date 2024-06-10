extends Node

var tool_id = 3
@onready var inventory = preload("res://_PROTO_/inventroy.tres")

func check():
	print("borger")
	return inventory.playerHas(tool_id)
