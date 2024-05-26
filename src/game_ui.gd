extends Control
@onready var health = $health
@onready var healthPool = $"../HealthPool"

# Called when the node enters the scene tree for the first time.
func _ready():
	if healthPool is HealthPool:
		healthPool.health_change.connect(_on_health_change)
		health.text = str(healthPool.curr_hp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_health_change(new_hp):
	health.text = str(new_hp)
