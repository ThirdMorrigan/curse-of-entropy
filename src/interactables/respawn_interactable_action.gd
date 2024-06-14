extends InteractableAction

@onready var omni_light_3d = $"../OmniLight3D"
var light : float
var light_target : float = 2.0
var on : bool = false


func _ready():
	if interactable is Interactable:
		interactable.interact.connect(_on_interact)
	add_to_group("respawn")
	turn_off()

func _on_interact():
	get_tree().call_group("respawn","turn_off")
	GameDataSingleton.respawn_point = interactable.position
	turn_on()

func turn_off():
	omni_light_3d.light_energy = 0
	light = 0
	on = false

func turn_on():
	on = true

func _process(delta):
	if on and !is_equal_approx(light,light_target):
		light = lerpf(light,light_target,delta)
		omni_light_3d.light_energy = light
