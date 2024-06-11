@tool
extends Marker3D

@export var creature : Resource
@export var func_godot_properties : Dictionary
@export var repetable : bool = false
@export var min_time : float = 20
@export var max_time : float = 30
@export var overwrite_loot_table: bool = false
@export var drop : int = 0
@onready var timer = $Timer

const PROTO_THRALL_1H = "res://scenes/creature/proto_thrall_1h.tscn"
const PROTO_THRALL_2H = "res://scenes/creature/proto_thrall_2h.tscn"

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
		if overwrite_loot_table:
			instance.loot_table = {100.0 : drop}

func _func_godot_apply_properties(props: Dictionary) -> void:
	match props["creature_id"]:
		0:
			creature = preload(PROTO_THRALL_1H)
		1:
			creature = preload(PROTO_THRALL_2H)
	repetable = props["repeatable"]
	if "min_time" in props:
		min_time = props["min_time"] as float
	if "max_time" in props:
		min_time = props["max_time"] as float
	if int(props["drop"]):
		drop = int(props["drop"])
		overwrite_loot_table = true


func _on_creature_death():
	overwrite_loot_table = false
	if repetable:
		timer.wait_time = randf_range(min_time,max_time)
		timer.start()

func _on_timer_timeout():
	spawn()
