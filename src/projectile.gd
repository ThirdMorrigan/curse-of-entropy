extends ShapeCast3D

class_name Projectile

var parent_attack : RangedAttack
var travelling : bool = false
var timer : Timer
var damage : DamageInstance
var timer_length : float = 0.5

var distance_travelled : float = 0.0
var max_distance : float
var speed : float
var collisions : int = 0
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
			for c in get_collision_count():
				object_hit = get_collider(c)
				if object_hit is Hurtbox:
					parent_attack.hit.emit()
					object_hit.damage(damage)
				
				elif object_hit is GrappleTarget :
					parent_attack.hit.emit()
				travelling = false
				if timer_length > 0.0 :
					timer = Timer.new()
					add_child(timer)
					timer.wait_time = timer_length
					timer.timeout.connect(_on_timer_timeout)
					timer.start()
				elif timer_length == 0.0 :
					_on_timer_timeout()
				elif object_hit.collision_layer & 0b11:
					_on_timer_timeout()
				#queue_free()
		elif distance_travelled > max_distance:
			_on_timer_timeout()
		global_position += target_position
		distance_travelled += speed * _delta

func _on_timer_timeout():
	free.emit()
	queue_free()
