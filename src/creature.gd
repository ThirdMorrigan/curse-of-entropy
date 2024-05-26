extends CharacterBody3D

class_name Creature

const JUMP_VELOCITY = 5.0

@export var speed = 3.0

enum State {IDLE, WALK, HURT, DIE, ATTACK_0, ATTACK_1, ATTACK_2, ATTACK_3, ATTACK_4, JUMP}

var attacks : Array[Attack]
var jump_target : Vector3
var jump_land_error = 0.5
var landed = true
signal state_changed
signal jump_reached
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var current_state : State :
	get:
		return current_state
	set(s):
		current_state = s
		state_changed.emit()

#var goal_vec : Vector3 = Vector3.ZERO
var goal_vel : Vector3 = Vector3.ZERO

func _ready():
	var _attacks = find_children("*", "Attack")
	for a in _attacks:
		if a is Attack:
			attacks.append(a)
	if attacks.size() > 5 : print("someone's got too many attacks :3")

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	match current_state:
		State.IDLE:
			if is_on_floor():
				velocity = Vector3.ZERO
		State.WALK:
			if is_on_floor():
				velocity = goal_vel
				rotation.y = lerp_angle(rotation.y, atan2(-goal_vel.x, -goal_vel.z), delta * 5)
		State.HURT:
			pass
		State.DIE:
			pass
		State.JUMP:
			jump(delta)
		_:						# ALL ATTACKS HERE :3
			if is_on_floor():
				velocity = Vector3.ZERO
			attacks[current_state - State.ATTACK_0].fire()
		

	
	move_and_slide()

func current_attack() -> int :
	return current_state - 4 if current_state > 3 else -1

func jump(delta):
	
	velocity = Vector3.ZERO
	position = position.slerp(jump_target,delta*JUMP_VELOCITY)
	if position.distance_to(jump_target) < jump_land_error:
		print("ahoy")
		landed = true
		


func die():
	
	pass
