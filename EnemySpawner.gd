@tool
extends Marker3D

@export var creature : Resource
@export var func_godot_properties : Dictionary
@export var repetable : bool = false
@onready var timer = $Timer

const PROTO_THRALL_1H = preload("res://scenes/creature/proto_thrall_1h.tscn")
const PROTO_THRALL_2H = preload("res://scenes/creature/proto_thrall_2h.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("spawner")
	timer.timeout.connect(_on_timer_timeout)
	spawn()


func spawn():
	timer.stop()
	if creature != null:
		var instance = creature.instantiate()
		add_child(instance)
		instance.creature_death.connect(_on_creature_death)

func _func_godot_apply_properties(props: Dictionary) -> void:
	match props["creature_id"]:
		0:
			creature = PROTO_THRALL_1H
		1:
			creature = PROTO_THRALL_2H
	repetable = props["repeatable"]
func _on_creature_death():
	if repetable:
		timer.wait_time = randf_range(20,30)
		timer.start()

func _on_timer_timeout():
	spawn()
