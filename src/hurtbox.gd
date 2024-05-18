extends Area3D

class_name Hurtbox

@export var damage_modifier : float = 1.0

var health_pool : HealthPool

func _ready():
	collision_mask = 0
	collision_layer = collision_layer & 0b111000
	if !collision_layer :
		print("deleting hurtbox with wrongly assigned collision layer")
		queue_free()

func damage(d : DamageInstance):
	d.damage *= damage_modifier
	health_pool.hurt(d)
