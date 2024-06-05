@tool
extends StaticBody3D

class_name FuncFriction

@export var func_godot_properties : Dictionary

func _func_godot_apply_properties(properties: Dictionary) -> void:
	physics_material_override = PhysicsMaterial.new()
	physics_material_override.friction = properties["friction"]
