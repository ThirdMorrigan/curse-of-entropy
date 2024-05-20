extends Node3D

class_name Attack

@export var damage_instances : Array[DamageInstance]
@export_flags("destructible:8","player:32","creature:16") var targets : int :
	get:
		return targets
	set(t):
		targets = t
		if cast != null:
			cast.collision_mask = t * 8.0
@export var hitbox_shape : Shape3D
@export var attack_origin : Node3D
@export var range : float :
	get:
		return range
	set(r):
		range = r
		if cast != null:
			cast.target_position = cast.target_position.normalized() * r
@export var ai_range_min : float = 0.0
@export var ai_range_max : float = 2.0
var cast : ShapeCast3D

func _ready():
	create_hitbox()

func fire() :
	if cast.is_colliding():
		for t in range(cast.get_collision_count()):
			var h = cast.get_collider(t)
			if h is Hurtbox:
				h.damage(damage_instances[0])

func create_hitbox():
	cast = ShapeCast3D.new()
	$"..".add_child(cast)
	cast.collide_with_areas = true
	cast.collide_with_bodies = false
	cast.exclude_parent = true
	targets = targets
	cast.shape = hitbox_shape
	cast.global_position = attack_origin.global_position if attack_origin != null else 1.0
	cast.target_position = Vector3.FORWARD * range
