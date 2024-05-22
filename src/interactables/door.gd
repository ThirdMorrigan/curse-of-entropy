@tool
extends Interactable

enum states {LOCKED,CLOSED,OPEN}
@export var state : states
@export var keyID : int = 0

@export var func_godot_properties : Dictionary

func _func_godot_apply_properties(props: Dictionary) -> void:
	print("door")
	#state = props["state"]
	keyID = props["key"]
