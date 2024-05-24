@tool
extends NavigationLink3D


@export var func_godot_properties : Dictionary


func _func_godot_apply_properties(props: Dictionary) -> void:
	set_navigation_layer_value(props["layer"], true)
	end_position = start_position + props["end_offset"]
