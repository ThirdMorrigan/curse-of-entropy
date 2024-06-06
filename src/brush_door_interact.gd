extends Door

class_name BrushDoorInteractible

var cam

func _ready():
	_interactable_ready()
	cam = get_viewport().get_camera_3d()
	$"..".finished_opening.connect(_on_finished_opening)
	
func _func_godot_apply_properties(props: Dictionary) -> void:
	state = props["state"] as int
	keyID = props["key"] as int

func wrong_side_test() -> bool: 
	var to_player = global_position - cam.global_position
	
	return false

func _on_finished_opening():
	opened.emit()

func start_opening():
	$"..".start_opening()
