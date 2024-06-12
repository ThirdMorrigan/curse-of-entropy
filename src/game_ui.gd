extends Control

@onready var healthPool = $"../HealthPool"
@onready var interactable = $interactable
@onready var ray_cast_3d = $"../camera_pivot/Camera3D/RayCast3D"
@onready var animation_player = $"AnimationPlayer"
@onready var death_message = $death_screen/death_message
@onready var face = $Character_info/face
@onready var timer = $Timer
@onready var maxhealth_missing_bar = $Character_info/healthbar/maxhealth_missing_bar
@onready var health_bar = $Character_info/healthbar/Health_bar
@onready var health_lost_bar = $Character_info/healthbar/Health_lost_bar
@onready var consumeable_quantity = $Character_info/consume/consumeable_quantity
@onready var mana_bar = $Character_info/healthbar/mana_bar
@onready var player = $".."

@onready var consumeable = $Character_info/consume/consumeable
@onready var tool = $Character_info/tool2/tool
var health_target : float
var health_lost_target : float
var mana_target : float

var character_details : PlayerCharacter:
	get:
		return character_details
	set(d):
		character_details = d
		update_data()

# Called when the node enters the scene tree for the first time.
func _ready():
	player.mana_changed.connect(_on_mana_change)
	if healthPool is HealthPool:
		healthPool.health_change.connect(_on_health_change)
		health_bar.value = healthPool.curr_hp
		health_target = healthPool.curr_hp
		health_lost_bar.value = healthPool.curr_hp
		health_lost_target = healthPool.curr_hp
		mana_bar.value = player.curr_mana
		print("mana" + str(player.curr_mana))
		mana_target = mana_bar.value
		maxhealth_missing_bar.value = healthPool.max_hp - healthPool.curr_max_hp
	if ray_cast_3d != null:
		ray_cast_3d.interactable_target_changed.connect(_on_interactable_look)
	

signal fade_complete

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(health_bar.value-health_target)
	if !is_equal_approx(health_bar.value,health_target):
		health_bar.value = move_toward(health_bar.value,health_target,delta*50)
		
	if !is_equal_approx(health_lost_bar.value,health_lost_target):
		print("eorg")
		health_lost_bar.value = move_toward(health_lost_bar.value,health_lost_target,delta*10)
	
	if !is_equal_approx(mana_bar.value,mana_target):
		mana_bar.value = move_toward(mana_bar.value,mana_target,delta*50)

func _on_health_change(new_hp,new_max):
	#health_bar.value = new_hp
	health_target = new_hp
	print(new_hp)
	maxhealth_missing_bar.value = healthPool.max_hp - healthPool.curr_max_hp
	timer.start()

func _on_interactable_look(interact_message):
	interactable.text = interact_message

func set_selected_item_text(consumeable_name,quant, tool_name):
	consumeable.text = consumeable_name
	consumeable_quantity.text = str(quant)
	tool.text = tool_name
	

func _on_player_player_death(died):
	if died:
		death_message.text = "you died for real"
		get_tree().call_group("char_select","new_character")
		animation_player.play("death_screen_fade_real")
	else:
		death_message.text = "you crawl away bearly surviving. It takes " + str(character_details.calculate_age_gain()) + " years for you to recover and return"
		animation_player.play("death_screen_fade")


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"death_screen_fade":
			fade_complete.emit()
			animation_player.play("death_screen_unfade")
		"death_screen_fade_real":
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func reload():
	fade_complete.emit()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animation_player.play("death_screen_unfade")

func update_data():
	face.update_face(character_details.face,character_details.hair,character_details.skin_colour,character_details.hair_colour)


func _on_timer_timeout():
	health_lost_target = healthPool.curr_hp

func _on_mana_change(new_mana,new_max):
	mana_target = new_mana
