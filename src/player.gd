extends CharacterBody3D

class_name Player

@export var speed : float = 3
@export var speed_crouch : float
@export var acceleration : float
@export var acceleration_air : float
@export var friction : float
@export var jump_power : float = 5
@export var coyote_frames : int = 6

var coyote_timer : int
var crouching : bool :
	get:
		return crouching
	set(c):
		if !$direction_pivot/uncrouch.is_colliding() || c :
			crouching = c
			$body_standing.disabled = c
			$Hurtbox/hurtbox_standing.disabled = c
			$body_crouching.disabled = !c
			$Hurtbox/hurtbox_crouching.disabled = !c
			camera_lerp = $crouching_camera_pos if c else $standing_camera_pos
			try_uncrouch = false
		elif !c :
			try_uncrouch = true
var try_uncrouch : bool = false
var camera_lerp : Node3D

var yaw : float :
	get:
		return rotation.y
	set(y):
		rotation.y = y
var pitch_camera : float :
	get:
		return $"camera_pivot".rotation.x
	set(x):
		x = clampf(x, -PI*0.45, PI*0.45)
		$"camera_pivot".rotation.x = x

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var input_dir : Vector3 = Vector3.ZERO
var can_jump : bool
var jumping : bool :
	get:
		return jumping
	set(j):
		if j && can_jump && coyote_timer :
			jump()
		jumping = j
		

func _ready():
	crouching = false

func _process(delta):
	if $camera_pivot.position.y != camera_lerp.position.y:
		var vert_move = move_toward($camera_pivot.position.y, camera_lerp.position.y, delta * 4) - $camera_pivot.position.y
		$camera_pivot.position.y += vert_move
		position.y -= vert_move
	if try_uncrouch :
		crouching = false

func _physics_process(delta):
	var floor_friction : float = 1.0
	if $floor_test.is_colliding() :
		var col = $floor_test.get_collider()
		if col is PhysicsBody3D:
			var pmo = col.physics_material_override
			if pmo != null:
				floor_friction = pmo.friction
				print(floor_friction)
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		if coyote_timer :
			coyote_timer-=1
	else : 
		coyote_timer = coyote_frames * int(!jumping)
		can_jump = !jumping
		
	var vel_v = velocity.y
	velocity.y = 0
	var edge_stop = !$direction_pivot/leading_ray.is_colliding() && !input_dir
	var temp_friction = friction
	temp_friction *= (10 if edge_stop else 1)
	temp_friction *= floor_friction
	velocity *= 1 - (delta * temp_friction * float(is_on_floor()))
	velocity += input_dir * delta * ((acceleration*floor_friction) if is_on_floor() else acceleration_air)
	velocity = velocity.limit_length(speed)
	velocity.y = vel_v

	move_and_slide()
	
	$direction_pivot.global_rotation.y = atan2(-velocity.x, -velocity.z)

func jump():
	velocity.y += jump_power

func die():
	
	pass
