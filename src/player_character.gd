extends Node
class_name PlayerCharacter

var character_name
var max_health
var age
var strength
var intelligence
@onready var health_pool : HealthPool = $"../HealthPool"

# Called when the node enters the scene tree for the first time.
func _ready():
	proto_char()
	$"..".player_death.connect(_on_player_death)
	$"../InventoryUI".character_details = self
	$"../game_ui".character_details = self


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
	var overkill = abs(health_pool.curr_hp)
	var max_health_lost = health_pool.max_hp - health_pool.curr_max_hp
	var years_gained = overkill + max_health_lost * 0.5
	age += years_gained
	return years_gained

func get_death_chance():
	var overkill = abs(health_pool.curr_hp)
	var max_health_lost = health_pool.max_hp - health_pool.curr_max_hp
	return overkill + max_health_lost * 0.1 + max(0,age - 30) * 2

func _on_player_death(died):
	if died:
		queue_free()
