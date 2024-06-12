extends Node

@onready var attack = $".."
@onready var player = $"../.."

@onready var inventory = preload("res://_PROTO_/inventroy.tres")

func check():
	return player.curr_mana > attack.mana_cost
