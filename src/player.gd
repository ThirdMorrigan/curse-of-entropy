extends CharacterBody3D

class_name Player

const SPEED = 5.0

var jump_power : float = 5

var yaw : float :
	get:
		return rotation.y
	set(y):
		rotation.y = y
var pitch_camera : float :
	get:
		return $"camera_pivot".rotation.x
	set(x):
		$"camera_pivot".rotation.x = x

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var input_dir : Vector3 = Vector3.ZERO



func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	
	if is_on_floor():
		if input_dir:
			velocity.x = input_dir.x * SPEED
			velocity.z = input_dir.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func jump():
	velocity.y += jump_power
