extends Node
class_name PlayerCharacter

var character_name
var max_health

var strength_ratio
var intelligence_ratio
var strength
var intelligence
var skin_colour : Color
var hair_colour : Color = Color(randf(),randf(),randf(),1)
var hair
var face
var hair_num
var face_num
var health_pool : HealthPool
const FACE_SCENE = preload("res://scenes/face.tscn")
const NAMES_JSON = preload("res://assets/data/names_json.tres")
var latest_age_loss = 0
var skin_tones = [
		Color(45,34,30),
		Color(60,46,40),
		Color(75,57,50),
		Color(90,69,60),
		Color(105,80,70),
		Color(120,92,80),
		Color(135,103,90),
		Color(150,114,100),
		Color(165,126,110),
		Color(180,138,120),
		Color(195,149,130),
		Color(210,161,140),
		Color(225,172,150),
		Color(240,184,160),
		Color(255,195,170),
		Color(255,206,180)
	]
var age:
	get:
		return age
	set(a):
		age = a
		update_stats()

# Called when the node enters the scene tree for the first time.
func _ready():
	#proto_char()
	skin_colour = skin_tones.pick_random() / Color(255,255,255)
	var temp_face = FACE_SCENE.instantiate()
	add_child(temp_face)
	hair_num = temp_face.hair.hframes
	face_num = temp_face.face.hframes
	temp_face.queue_free()
	random_character()
	

func connect_player():
	$"..".player_death.connect(_on_player_death)
	$"../InventoryUI".character_details = self
	$"../game_ui".character_details = self
	$"../viewmodel_animation_tree".character_details = self
	health_pool = $"../HealthPool"


func proto_char():
	character_name = "proto"
	max_health = 100
	age = 80
	strength = 10
	intelligence = 5

func random_character():
	intelligence_ratio = randf_range(2,3)
	strength_ratio = 4 - intelligence_ratio
	hair = randi_range(0, hair_num-1)
	face = randi_range(0, face_num-1)
	var first_name = NAMES_JSON.data.pick_random()["GivenName"]
	var last_name = NAMES_JSON.data.pick_random()["Surname"]
	character_name = first_name + " " + last_name
	max_health = 100
	age = randi_range(18,30)

func child_character():
	intelligence_ratio = randf_range(2,3)
	strength_ratio = 4 - intelligence_ratio
	hair = randi_range(0, hair_num-1)
	face = randi_range(0, face_num-1)
	var first_name = NAMES_JSON.data.pick_random()["GivenName"]
	var last_name = NAMES_JSON.data.pick_random()["Surname"]
	character_name = first_name + " " + last_name
	max_health = 100
	age = randi_range(18,30)

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
	#print_debug(overkill + max_health_lost + max(0,age - 20) * 2)
	return overkill + max_health_lost + (max(0,age - 20) * 2)

func _on_player_death(died):
	if died:
		queue_free()

func update_stats():
	var base = (float(age) * 0.25 -9)
	var power = -1.0 * pow(base,2)
	strength = int(strength_ratio * (power +100))
	intelligence = int(age * intelligence_ratio)
