extends CharacterBody3D

class_name Player

@export var speed : float = 3
@export var acceleration : float
@export var friction : float
@export var jump_power : float = 5
@export var coyote_frames : int = 6

var coyote_timer : int
var crouching : bool :
	get:
		return crouching
	set(c):
		crouching = c
		$body_standing.disabled = c
		$Hurtbox/hurtbox_standing.disabled = c
		$body_crouching.disabled = !c
		$Hurtbox/hurtbox_crouching.disabled = !c
		camera_lerp = $crouching_camera_pos if c else $standing_camera_pos
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
		if j && !jumping && can_jump && coyote_timer :
			if !is_on_floor() && coyote_timer:
				print("coyote'd")
			jump()
		jumping = j
		

func _ready():
	crouching = false

func _process(delta):
	if $camera_pivot.position.y != camera_lerp.position.y:
		var vert_move = move_toward($camera_pivot.position.y, camera_lerp.position.y, delta * 4) - $camera_pivot.position.y
		$camera_pivot.position.y += vert_move
		#if vert_move < 0:
		position.y -= vert_move

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
		if coyote_timer :
			coyote_timer-=1
		
	
	if is_on_floor():
		coyote_timer = coyote_frames * int(!jumping)
		can_jump = !jumping
		if input_dir:
			velocity.x = input_dir.x * speed
			velocity.z = input_dir.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func jump():
	velocity.y += jump_power

func die():
	
	pass
