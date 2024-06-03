extends Node
class_name PlayerCharacter

var character_name
var max_health
var age
var strength
var intelligence
@onready var health_pool : HealthPool = $"../HealthPool"
var latest_age_loss
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

func calculate_age_gain():
	var overkill = abs(health_pool.curr_hp)
	var max_health_lost = 100 - ( health_pool.curr_max_hp / health_pool.max_hp) * 100
	var years_gained = int(overkill + max_health_lost * 0.1 + randi_range(1,5))
	latest_age_loss = years_gained
	return years_gained

func get_older():
	age += latest_age_loss
	

func get_death_chance():
	var overkill = abs(health_pool.curr_hp)
	var max_health_lost = health_pool.max_hp - health_pool.curr_max_hp
	print_debug(overkill + max_health_lost + max(0,age - 20) * 2)
	return overkill + max_health_lost + (max(0,age - 20) * 2)

func _on_player_death(died):
	if died:
		queue_free()
