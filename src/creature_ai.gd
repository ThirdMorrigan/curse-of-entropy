extends Node

class_name CreatureAI

@export var eyes : Node3D

@export var wander_range : float = 10
@export var wander_wait_min : float = 1.0
@export var wander_wait_max : float = 8.0
@export var ai_tickrate : int = 4
@export var vision_range : float = 15
@export var vision_angle : float = 45
var attacks : Array[Attack]

var creature : Creature
var nav : NavigationAgent3D
var vision_area : Area3D

var wander_goal : Vector3 = Vector3.ZERO
var current_nav_goal : Vector3
var goal_vel : Vector3

var player : Player
var player_last_seen : Vector3
var absolute_distance_to_player : float

var exit_ai_loop : bool = false
@onready var mut : Mutex = Mutex.new()
@onready var sem : Semaphore = Semaphore.new()
@onready var ai_loop : Thread = Thread.new()
var ai_ticker : int 
var waiting : bool 
@onready var waiting_thread : Thread = Thread.new()

var next_state : Creature.State

var home : Vector3

var safe_velocity_lockout : bool = false

func _ready():
	if $".." is Creature :
		creature = $".."
	else :
		queue_free()
	nav = creature.find_children("*", "NavigationAgent3D")[0]
	attacks = creature.attacks
	if !(nav is NavigationAgent3D):
		print("dies xd")
		queue_free()
	
	##nav.target_position = wander_goal
	if $"../nav" != null:
		$"../nav".link_reached.connect(_on_link_reached)
	nav.target_reached.connect(_on_target_reached)
	nav.max_speed = creature.speed
	nav.velocity_computed.connect(_on_velocity_computed)
	creature.current_state = Creature.State.IDLE
	
	
	home = creature.global_position
	
	randomize()
	ai_ticker = randi_range(0,ai_tickrate)
	
	set_physics_process(false)
	await get_tree().physics_frame
	await get_tree().physics_frame
	set_physics_process(true)			# this just avoids an error :3
	
	vision_area = Area3D.new()
	eyes.add_child(vision_area)
	var vision_area_shape = CollisionShape3D.new()
	vision_area.add_child(vision_area_shape)
	vision_area_shape.shape = SphereShape3D.new()
	vision_area_shape.shape.radius = vision_range
	
	wander_goal = random_pos_in_wander_range()
	
	
	ai_loop.start(_ai_loop)
	
func _physics_process(_delta):
	if creature.current_state == Creature.State.DIE:
		nav.queue_free()
		queue_free()
		
	if !ai_ticker:
		sem.post()
		ai_ticker += ai_tickrate
	ai_ticker -= 1
	
	mut.lock()
	if next_state != creature.current_state:
		creature.current_state = next_state
	nav.target_position = current_nav_goal
	if player != null:														# LOOKING FOR PLAYER
		player_last_seen = player.global_position
		absolute_distance_to_player = (player.global_position - creature.global_position).length()
	mut.unlock()
	
	var goal_temp = (nav.get_next_path_position() - creature.global_position) * Vector3(1,0,1)
	goal_temp = goal_temp.normalized() * creature.speed
	if !safe_velocity_lockout:
		nav.set_velocity(goal_temp)
		safe_velocity_lockout = true
	creature.goal_vel = goal_temp#goal_vel
	
func _on_target_reached():
	if player == null && creature.current_state == Creature.State.WALK && !waiting :
		wander_goal = random_pos_in_wander_range()
		if waiting_thread.is_started() : waiting_thread.wait_to_finish()
		waiting_thread.start(wait)

func _ai_loop():
	while true:
		sem.wait()
		
		mut.lock()
		var e = exit_ai_loop
		mut.unlock()
		if e : break
		
		if player == null :
			mut.lock()
			if wander_range :
				if waiting:
					next_state = Creature.State.IDLE
				else:
					next_state = Creature.State.WALK
					if current_nav_goal != wander_goal:
						current_nav_goal = wander_goal
			mut.unlock()
		else:
			var num_attacks = min(attacks.size(),5)
			var picked_attack : int = -1
			mut.lock()
			if num_attacks:
				for _a in range(num_attacks-1, -1, -1):
					if attacks[_a].ai_range_min < absolute_distance_to_player && absolute_distance_to_player < attacks[_a].ai_range_max:
						picked_attack = _a
			if picked_attack > -1:
				next_state = Creature.State.ATTACK_0 + picked_attack
			elif creature.landed:
				current_nav_goal = player_last_seen
				next_state = Creature.State.WALK
			else:
				next_state = Creature.State.JUMP
			mut.unlock()
	
func wait():
	randomize()
	var t = randf_range(wander_wait_min, wander_wait_max)
	mut.lock()
	waiting = true
	mut.unlock()
	await get_tree().create_timer(t).timeout
	mut.lock()
	waiting = false
	mut.unlock()
	

func random_pos_in_wander_range() -> Vector3:
	var final : Vector3 = creature.global_position
	for c in range(10):
		if ( final - creature.global_position ).length_squared() < 1.0 :
			randomize()
			var v = Vector3(randf(),randf(),randf()).normalized()
			var r = ease(randf(), 0.4) * wander_range
			v *= r
			final = NavigationServer3D.map_get_closest_point(creature.get_world_3d().navigation_map, home + v)
		else:
			break
		
	return final
	

func _on_link_reached(details):
	var link : NavigationLink3D = details["owner"]
	if link.navigation_layers > 63:
		next_state = Creature.State.JUMP
		creature.landed = false
		creature.jump_target =  details["link_exit_position"]

func _exit_tree():
	mut.lock()
	exit_ai_loop = true
	mut.unlock()
	sem.post()
	ai_loop.wait_to_finish()
	waiting_thread.wait_to_finish()

func _on_velocity_computed(vel : Vector3):
	goal_vel = vel
	safe_velocity_lockout = false
