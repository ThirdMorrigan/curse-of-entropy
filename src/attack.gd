extends Node3D

class_name Attack

signal hit

var requirement

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
	requirement = get_node_or_null("requirement")
	create_hitbox()

func fire() :
	if attack_origin != null :
		cast.global_position = attack_origin.global_position
		cast.global_rotation = attack_origin.global_rotation
	cast.force_shapecast_update()
	if cast.is_colliding():
		for t in range(cast.get_collision_count()):
			var h = cast.get_collider(t)
			if h is Hurtbox:
				hit.emit()
				var d = get_modified_damage_instance(damage_instances[0])
				print(d.impulse)
				h.damage(d)

func create_hitbox():
	cast = _create_hitbox()
	$"..".add_child(cast)
	cast.collide_with_areas = true
	cast.collide_with_bodies = false
	cast.exclude_parent = true
	cast.collision_mask += targets #* 8.0
	#print(cast.collision_mask)
	cast.shape = hitbox_shape
	cast.global_position = attack_origin.global_position if attack_origin != null else Vector3(0.0, 1.0, 0.0)
	cast.global_rotation = attack_origin.global_rotation if attack_origin != null else Vector3.ZERO
	cast.target_position = Vector3.FORWARD * range

func _create_hitbox() -> ShapeCast3D:
	var h = ShapeCast3D.new()
	h.collision_mask = 0b0
	return h

func get_modified_damage_instance(d : DamageInstance) -> DamageInstance :
	var d_temp = d.copy()
	print(str(d.impulse, ", ", d_temp.impulse))
	d_temp.rotate_impulse(global_basis)
	return d_temp

func check() -> bool:
	if requirement == null:
		print("attack should have attached requirent if it is going to be checked")
		return false
	return requirement.check()
