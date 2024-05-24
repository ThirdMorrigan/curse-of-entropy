extends Area3D

class_name Hurtbox

@export var damage_modifier : float = 1.0

@export var copy_collision_shapes : Array[CollisionShape3D]

var health_pool : HealthPool


func _ready():
	monitoring = false
	collision_mask = 0
	collision_layer = collision_layer & 0b111000
	if !collision_layer :
		print("deleting hurtbox with wrongly assigned collision layer")
		queue_free()
	if copy_collision_shapes.size() :
		for s in copy_collision_shapes:
			var _s : CollisionShape3D = CollisionShape3D.new()
			var _r : RemoteTransform3D = RemoteTransform3D.new()
			_r.remote_path = _r.get_path_to(_s)
			s.add_child(_r)
			add_child(_s)
		copy_collision_shapes = []

func damage(d : DamageInstance):
	d.damage *= damage_modifier
	health_pool.hurt(d)




