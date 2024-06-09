extends ShapeCast3D

class_name Projectile

var parent_attack : RangedAttack
var travelling : bool = false

var damage : DamageInstance

func set_movement_vector(direction : Vector3, speed : float):
	target_position = direction * speed * get_physics_process_delta_time()
	if damage != null :
		damage.impulse_vector = direction

func _physics_process(delta):
	if travelling:
		force_shapecast_update()
		if is_colliding():
			var h = get_collider(0)
			if h is Hurtbox:
				parent_attack.hit.emit()
				h.hurt()
			travelling = false
			#queue_free()
		global_position += target_position

