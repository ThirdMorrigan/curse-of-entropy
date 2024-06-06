@tool
extends Interactable
class_name Door

enum states {LOCKED,CLOSED,OPEN, ONEWAY}
@export var state : states
@export var keyID : int = 0

@export var func_godot_properties : Dictionary

signal opened

func _ready():
	_interactable_ready()
	set_interaction_text()
	
func _func_godot_apply_properties(props: Dictionary) -> void:
	state = props["state"] as int
	keyID = props["key"] as int

func _physics_process(delta):
	if !Engine.is_editor_hint():
		set_interaction_text()

func set_interaction_text():
	var text = ""
	match state:
		states.LOCKED:
			text = "locked"
		states.CLOSED:
			text = "open"
		states.ONEWAY:
			if wrong_side_test():
				text = "open"
			else:
				text = "can't be opened from this side"
	interactionText = text

func wrong_side_test() -> bool: 
	return $Area3D.get_overlapping_areas().size()
