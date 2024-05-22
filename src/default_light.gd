@tool
class_name LightOmni
extends OmniLight3D

@export var func_godot_properties : Dictionary

func _ready():
	pass

func _func_godot_apply_properties(props: Dictionary) -> void:
	print("building light")
	light_energy = props["energy"] as float
	light_color = props["colour"] as Color
