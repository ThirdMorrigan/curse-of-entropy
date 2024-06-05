@tool
extends Interactable


@export var target_group : String =  ""
@export var func_godot_properties : Dictionary
@export var bidirectional : bool = false 
var pulled = false

func _ready():
	interactionText = "pull"

func _func_godot_apply_properties(props: Dictionary) -> void:
	target_group = props["target"]
