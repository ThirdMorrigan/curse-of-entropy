@tool
extends Interactable

@export var func_godot_properties : Dictionary
@export var id : int = 0

func _func_godot_apply_properties(props: Dictionary) -> void:
	print("e")
	id = props["id"]
