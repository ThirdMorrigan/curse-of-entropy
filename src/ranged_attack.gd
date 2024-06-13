extends Attack

class_name RangedAttack

@export var visuals : PackedScene

var aim_vector : Vector3 = Vector3.FORWARD

func _create_hitbox():
	var p = Projectile.new()
	p.parent_attack = self
	p.collision_mask = 0b11
	return p

func fire():
	if spell:
		scale_attack()
	cast.damage = damage_instances[0]
	cast.set_movement_vector((attack_origin.global_basis * Vector3.FORWARD) * attack_range,1)
	cast.global_rotation = Vector3.ZERO
	var _vis = visuals.instantiate()
	if visuals != null :
		cast.add_child(_vis)
		_vis.position = Vector3.ZERO
		_vis.global_basis = attack_origin.global_basis
	cast.travelling = true
	cast.top_level = true
	create_hitbox()
	##print(cast)
