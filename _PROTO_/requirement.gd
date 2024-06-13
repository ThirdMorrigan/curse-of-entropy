extends Node

@onready var attack = $".."
@onready var player = $"../.."

@onready var inventory = preload("res://_PROTO_/inventroy.tres")

func check():
	return inventory.get_quantity(3)
