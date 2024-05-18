extends Area3D

class_name Hurtbox

@export var damage_modifier : float = 1.0

@export var copy_collision_shapes : Array[CollisionShape3D]

var health_pool : HealthPool

func _ready():
	collision_mask = 0
	collision_layer = collision_layer & 0b111000
	if !collision_layer :
		print("deleting hurtbox with wrongly assigned collision layer")
		queue_free()
	if copy_collision_shapes.size() :
		for s in copy_collision_shapes:
			var _s : CollisionShape3D = CollisionShape3D.new()
			_s.transform = s.transform
			_s.shape = s.shape
			add_child(_s)
		copy_collision_shapes = []

func damage(d : DamageInstance):
	d.damage *= damage_modifier
	health_pool.hurt(d)
