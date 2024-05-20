extends CharacterBody3D

class_name Creature

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

enum State {IDLE, WALK, HURT, DIE, ATTACK_0, ATTACK_1, ATTACK_2, ATTACK_3, ATTACK_4}

var attacks : Array[Attack]

signal state_changed

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
		_:						# ALL ATTACKS HERE :3
			attacks[current_state - State.ATTACK_0].fire()

	
	move_and_slide()

func current_attack() -> int :
	return current_state - 4 if current_state > 3 else -1


func die():
	
	pass
