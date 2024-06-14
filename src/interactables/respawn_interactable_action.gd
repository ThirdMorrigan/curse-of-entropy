extends InteractableAction

@onready var omni_light_3d = $"../OmniLight3D"


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

func turn_on():
	print("on now")
	omni_light_3d.light_energy = 2
	
