extends Control

@onready var health = $health
@onready var healthPool = $"../HealthPool"
@onready var interactable = $interactable
@onready var ray_cast_3d = $"../camera_pivot/Camera3D/RayCast3D"
@onready var animation_player = $"death_screen/AnimationPlayer"
@onready var death_message = $death_screen/death_message
var character_details : PlayerCharacter

# Called when the node enters the scene tree for the first time.
func _ready():
	if healthPool is HealthPool:
		healthPool.health_change.connect(_on_health_change)
		health.text = str(healthPool.curr_hp) + " / " + str(healthPool.curr_max_hp)
	if ray_cast_3d != null:
		ray_cast_3d.interactable_target_changed.connect(_on_interactable_look)
	

signal fade_complete

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_health_change(new_hp,new_max):
	health.text = str(new_hp) + " / " + str(new_max)

func _on_interactable_look(interact_message):
	interactable.text = interact_message


func _on_player_player_death(died):
	if died:
		death_message.text = "you died for real"
		animation_player.play("death_screen_fade_real")
	else:
		death_message.text = "you crawl away bearly surviving. It takes " + str(character_details.calculate_age_gain()) + " years for you to recover and return"
		animation_player.play("death_screen_fade")


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"death_screen_fade":
			fade_complete.emit()
			animation_player.play("death_screen_unfade")
