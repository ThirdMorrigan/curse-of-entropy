extends Node
class_name PlayerCharacter

var character_name
var max_health
var age
var strength
var intelligence

# Called when the node enters the scene tree for the first time.
func _ready():
	proto_char()
	$"../InventoryUI".character_details = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func proto_char():
	character_name = "proto"
	max_health = 100
	age = 22
	strength = 10
	intelligence = 5

func get_older():
	age += 10
