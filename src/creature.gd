extends CharacterBody3D

class_name Creature

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

enum State {IDLE, WALK, HURT, DIE, ATTACK_0, ATTACK_1, ATTACK_2, ATTACK_3, ATTACK_4}

@export var attacks : Array

signal state_changed

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var current_state : State :
	get:
		return current_state
	set(s):
		current_state = s
		state_changed.emit()

var goal_vec : Vector3 = Vector3.ZERO


func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	match current_state:
		State.IDLE:
			if is_on_floor():
				velocity = Vector3.ZERO
		State.WALK:
			if is_on_floor():
				velocity = goal_vec * SPEED
		State.HURT:
			pass
		State.DIE:
			pass
		_:						# ALL ATTACKS HERE :3
			pass

	if goal_vec:
		look_at(goal_vec + global_position)
	
	move_and_slide()

func current_attack() -> int :
	return current_state - 4 if current_state > 3 else null
