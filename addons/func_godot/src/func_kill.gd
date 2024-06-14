@tool
extends StaticBody3D

@export var func_godot_properties : Dictionary
@export var group : String

func _ready():
	add_to_group(group)

func _func_godot_apply_properties(properties: Dictionary) -> void:
	group = properties["target_activation_group"]


func activate():
	queue_free()
