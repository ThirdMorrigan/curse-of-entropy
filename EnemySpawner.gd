@tool
extends Marker3D

@export var creature : Resource
@export var func_godot_properties : Dictionary
@export var repetable : bool = false
@export var min_time : float = 20
@export var max_time : float = 30
@export var overwrite_loot_table: bool = false
@export var drop : int = 0
@export var boss : bool = false
@export var wander_range : float
var dead : bool = false
@onready var timer = $Timer

const PROTO_THRALL_1H = "res://scenes/creature/proto_thrall_1h.tscn"
const PROTO_THRALL_2H = "res://scenes/creature/proto_thrall_2h.tscn"
const THRALL_SICLE = "res://scenes/creature/thralls/thrall_sicle.tscn"
const THRALL_PITCHFORK = "res://scenes/creature/thralls/thrall_pitchfork.tscn"
const THRALL_PICKAXE_SMALL = "res://scenes/creature/thralls/thrall_pickaxe_1h.tscn"
const THRALL_PICKAXE_LARGE = "res://scenes/creature/thralls/thrall_pickaxe_2h.tscn"
const THRALL_SWORD = "res://scenes/creature/thralls/thrall_sword.tscn"
const THRALL_SPEAR = "res://scenes/creature/thralls/thrall_spear.tscn"
const THRALL_POLEARM = "res://scenes/creature/thralls/thrall_polearm.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("spawner")
	timer.timeout.connect(_on_timer_timeout)
	spawn()


func spawn():
	if not dead:
		timer.stop()
		if creature != null:
			var instance = creature.instantiate()
			instance.wander_range = wander_range
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
		2:
			creature = preload(THRALL_SICLE)
		3:
			creature = preload(THRALL_PITCHFORK)
		4:
			creature = preload(THRALL_PICKAXE_SMALL)
		5:
			creature = preload(THRALL_PICKAXE_LARGE)
		6:
			creature = preload(THRALL_SWORD)
		7:
			creature = preload(THRALL_SPEAR)
		8:
			creature = preload(THRALL_POLEARM)
	
	repetable = props["repeatable"]
	boss = props["boss"]
	wander_range = props["wander"]
	if "min_time" in props:
		min_time = props["min_time"] as float
	if "max_time" in props:
		min_time = props["max_time"] as float
	if int(props["drop"]):
		drop = int(props["drop"])
		overwrite_loot_table = true


func _on_creature_death():
	overwrite_loot_table = false
	if boss:
		dead = true
	if repetable:
		timer.wait_time = randf_range(min_time,max_time)
		timer.start()

func _on_timer_timeout():
	spawn()
