@tool
class_name LightOmni
extends OmniLight3D

@export var func_godot_properties : Dictionary

func _ready():
	_func_godot_apply_properties(func_godot_properties)
	pass

func _func_godot_apply_properties(props: Dictionary) -> void:
	print(props)
	light_energy = props["Energy"]
