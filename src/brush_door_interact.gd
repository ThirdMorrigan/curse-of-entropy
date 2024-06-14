extends Door

class_name BrushDoorInteractible

var cam

func _ready():
	_interactable_ready()
	cam = get_viewport().get_camera_3d()
	$"..".opened.connect(_on_finished_opening)
	
func _func_godot_apply_properties(props: Dictionary) -> void:
	state = props["state"] as states
	keyID = props["key"] as int

func wrong_side_test() -> bool: 
	var to_player = global_position - cam.global_position
	return to_player.dot($"..".openable_from) < 0.0

func _on_finished_opening():
	opened.emit()
	_on_opened()

func start_opening():
	$"..".start_opening()
