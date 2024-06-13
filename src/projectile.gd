extends ShapeCast3D

class_name Projectile

var parent_attack : RangedAttack
var travelling : bool = false
var timer : Timer
var damage : DamageInstance

var distance_travelled : float = 0.0
var max_distance : float
var speed : float

var object_hit = null

signal free

func set_movement_vector(direction : Vector3, speed : float):
	target_position = direction * speed * get_physics_process_delta_time()
	self.speed = speed
	if damage != null :
		damage.impulse_vector = direction

func _physics_process(_delta):
	if travelling:
		force_shapecast_update()
		if is_colliding():
			object_hit = get_collider(0)
			if object_hit is Hurtbox:
				parent_attack.hit.emit()
				object_hit.damage(damage)
			elif object_hit is GrappleTarget :
				parent_attack.hit.emit()
			travelling = false
			timer = Timer.new()
			add_child(timer)
			timer.wait_time = 5
			timer.timeout.connect(_on_timer_timeout)
			timer.start()
			#queue_free()
		elif distance_travelled > max_distance:
			_on_timer_timeout()
		global_position += target_position
		distance_travelled += speed * _delta

func _on_timer_timeout():
	free.emit()
	queue_free()
