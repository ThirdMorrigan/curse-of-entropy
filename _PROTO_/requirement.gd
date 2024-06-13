extends Node

@onready var attack = $".."
@onready var player = $"../.."

@onready var inventory = preload("res://_PROTO_/inventroy.tres")



func check():
	return player.curr_mana > scale_cost()

func scale_cost():
	var inteli = player.character.intelligence
	var discount = (150.0 - inteli) / 100.0
	return (attack.mana_cost * discount)
