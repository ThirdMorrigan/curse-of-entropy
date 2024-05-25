@tool
extends Interactable

@export var func_godot_properties : Dictionary


func _func_godot_apply_properties(props: Dictionary) -> void:
	id = props["id"]
