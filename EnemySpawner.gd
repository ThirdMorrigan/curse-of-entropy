@tool
extends Marker3D

@export var creature : Resource
@export var func_godot_properties : Dictionary

const PROTO_THRALL_1H = preload("res://scenes/creature/proto_thrall_1h.tscn")
const PROTO_THRALL_2H = preload("res://scenes/creature/proto_thrall_2h.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("spawner")
	spawn()


func spawn():
	if creature != null:
		add_child(creature.instantiate())

func _func_godot_apply_properties(props: Dictionary) -> void:
	match props["creature_id"]:
		0:
			creature = PROTO_THRALL_1H
		1:
			creature = PROTO_THRALL_2H
