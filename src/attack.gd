extends Node3D

class_name Attack

signal hit

@export var damage_instances : Array[DamageInstance]
@export_flags("destructible:8","player:16","creature:32") var targets : int :
	get:
		return targets
	set(t):
		targets = t
		if cast != null:
			cast.collision_mask = t #* 8.0
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
@export var weight : float = 1.0
@export var wind_down : float = 1.0
var cast : ShapeCast3D

func _ready():
	await get_tree().physics_frame
	create_hitbox()

func fire() :
	cast.force_shapecast_update()
	if attack_origin != null :
		cast.global_position = attack_origin.global_position
		cast.global_rotation = attack_origin.global_rotation
	if cast.is_colliding():
		for t in range(cast.get_collision_count()):
			var h = cast.get_collider(t)
			if h is Hurtbox:
				hit.emit()
				h.damage(get_modified_damage_instance(damage_instances[0]))

func create_hitbox():
	cast = ShapeCast3D.new()
	$"..".add_child(cast)
	cast.collide_with_areas = true
	cast.collide_with_bodies = false
	cast.exclude_parent = true
	cast.collision_mask = targets #* 8.0
	print(cast.collision_mask)
	cast.shape = hitbox_shape
	cast.global_position = attack_origin.global_position if attack_origin != null else Vector3(0.0, 1.0, 0.0)
	cast.global_rotation = attack_origin.global_rotation if attack_origin != null else Vector3.ZERO
	cast.target_position = Vector3.FORWARD * range

func get_modified_damage_instance(d : DamageInstance) -> DamageInstance :
	var d_temp = d.copy()
	d_temp.rotate_impulse(global_basis)
	return d_temp
