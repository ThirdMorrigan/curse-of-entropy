@tool
extends NavigationLink3D


@export var func_godot_properties : Dictionary


func _func_godot_apply_properties(props: Dictionary) -> void:
	var layers = props["layers"].split(" ",false,0)
	for layer in layers:
			set_navigation_layer_value(int(layer), true)
	end_position = start_position + props["end_offset"]
	bidirectional = props["bidirectional"]
