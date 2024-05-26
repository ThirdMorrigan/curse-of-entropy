extends Control
@onready var health = $health
@onready var healthPool = $"../HealthPool"
@onready var interactable = $interactable
@onready var ray_cast_3d = $"../camera_pivot/Camera3D/RayCast3D"


# Called when the node enters the scene tree for the first time.
func _ready():
	if healthPool is HealthPool:
		healthPool.health_change.connect(_on_health_change)
		health.text = str(healthPool.curr_hp)
	if ray_cast_3d != null:
		ray_cast_3d.interactable_target_changed.connect(_on_interactable_look)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_health_change(new_hp):
	health.text = str(new_hp)

func _on_interactable_look(interact_message):
	interactable.text = interact_message
