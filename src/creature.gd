extends CharacterBody3D

class_name Creature

const JUMP_VELOCITY = 5.0
const PICKUP = preload("res://scenes/pickup.tscn")

@export var speed = 3.0
@export var loot_table : Dictionary
@export var overwirte_target_position: Marker3D
enum State {IDLE, WALK, HURT, DIE, ATTACK_0, ATTACK_1, ATTACK_2, ATTACK_3, ATTACK_4, JUMP}

var attacks : Array[Attack]
var jump_target : Vector3
var jump_land_error = 0.5
var landed = true
var track_target : bool = true
signal state_changed
signal jump_reached
signal creature_death
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var current_state : State :
	get:
		return current_state
	set(s):
		current_state = s
		state_changed.emit()

var goal_look : Vector3
var goal_vel : Vector3 = Vector3.ZERO
var to_impulse : Vector3 = Vector3.ZERO

var aware : bool = false

func _ready():
	goal_look = basis * Vector3.FORWARD
	add_to_group("creature")
	var _attacks = find_children("*", "Attack")
	for a in _attacks:
		if a is Attack:
			attacks.append(a)
	if attacks.size() > 5 : print("someone's got too many attacks :3")

func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if to_impulse :
		velocity += to_impulse
		to_impulse = Vector3.ZERO
		
	match current_state:
		State.IDLE:
			if is_on_floor():
				velocity = Vector3.ZERO
		State.WALK:
			if is_on_floor():
				velocity = goal_vel
				if track_target  : global_rotation.y = lerp_angle(global_rotation.y, atan2(-goal_look.x, -goal_look.z), delta * 5)
		State.HURT:
			pass
		State.DIE:
			move_and_slide()
			set_physics_process(false)
			#stop()
		State.JUMP:
			jump(delta)
		_:						# ALL ATTACKS HERE :3
			if is_on_floor():
				velocity = Vector3.ZERO
				if track_target : global_rotation.y = lerp_angle(global_rotation.y, atan2(-goal_look.x, -goal_look.z), delta * 10)
			#attacks[current_state - State.ATTACK_0].fire()
	
	move_and_slide()

func current_attack() -> int :
	return current_state - 4 if current_state > 3 else -1

func jump(delta):
	
	velocity = Vector3.ZERO
	position = position.slerp(jump_target,delta*speed)
	velocity = position.direction_to(jump_target)
	rotation.y = lerp_angle(rotation.y, atan2(-goal_vel.x, -goal_vel.z), delta * 5)
	if position.distance_to(jump_target) < jump_land_error:
		landed = true
		

func roll_loot_table():
	var roll = randf_range(0.0,100.0)
	var chances = loot_table.keys()
	var count = 0
	while count < chances.size():
		print(chances[count])
		if roll < chances[count]:
			var drop = PICKUP.instantiate()
			
			var properites = {
				"id" : loot_table[chances[count]],
				"quantity" : 1
			}
			drop._func_godot_apply_properties(properites)
			$"..".add_child(drop)
			drop.global_position = global_position
			break
		count +=1
			

func impulse(i : Vector3):
	aware = true
	to_impulse += i

func stop():
	if $CreatureAI != null:
		$CreatureAI.queue_free()
	pass
	
func delete():
	queue_free()


func die():
	creature_death.emit()
	roll_loot_table()
	#queue_free()
	current_state = State.DIE
	pass
