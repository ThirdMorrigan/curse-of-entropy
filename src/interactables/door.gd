@tool
extends Interactable

enum states {LOCKED,CLOSED,OPEN}
@export var state : states
@export var keyID : int = 0

@export var func_godot_properties : Dictionary

func _func_godot_apply_properties(props: Dictionary) -> void:
	print(props)
	#if "angle" in props:
		#rotation_degrees.y = props["angle"] as float
		#print(rotation_degrees)
	state = props["state"] as int
	keyID = props["key"] as int
