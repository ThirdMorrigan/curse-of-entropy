extends Area3D

class_name Hurtbox

@export var damage_modifier : float = 1.0

var health_pool : HealthPool

func damage(d : DamageInstance):
	d.damage *= damage_modifier
	health_pool.hurt(d)
