extends Node

class_name CreatureAI

@export var eyes : Node3D

@export var wander_range : float = 10
@export var wander_wait_min : float = 1.0
@export var wander_wait_max : float = 8.0
@export var ai_tickrate : int = 4
@export var vision_range : float = 15
@export var vision_angle : float = 45

var overwirte_target_position : Marker3D
var attacks : Array[Attack]
var attack_timer : float = 0.0

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
	
	overwirte_target_position = creature.overwirte_target_position
	##nav.target_position = wander_goal
	nav.link_reached.connect(_on_link_reached)
	nav.target_reached.connect(_on_target_reached)
	nav.path_changed.connect(_on_path_changed)
	nav.velocity_computed.connect(_on_velocity_computed)
	nav.max_speed = creature.speed
	#print("setting state in ai ready")
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
	vision_area.collision_mask = 16
	vision_area.collision_layer = 0

	wander_goal = random_pos_in_wander_range()

	
	ai_loop.start(_ai_loop)
	
func _physics_process(delta):
	if overwirte_target_position != null:
		print(current_nav_goal)
	if creature.current_state == Creature.State.DIE:
		nav.queue_free()
		queue_free()
		
	if !ai_ticker:
		sem.post()
		ai_ticker += ai_tickrate
	ai_ticker -= 1
	
	mut.lock()
	if next_state != creature.current_state:
		if !(next_state >= Creature.State.ATTACK_0 && creature.current_state == Creature.State.IDLE) :
			creature.current_state = next_state
	if creature.current_state < Creature.State.ATTACK_0 :
		attack_timer -= delta
	if overwirte_target_position == null:
		nav.target_position = current_nav_goal
	else:
		nav.target_position = overwirte_target_position.position
	if player != null:														# LOOKING FOR PLAYER
		if look_for(player):
			player_last_seen = player.global_position
		absolute_distance_to_player = (player.global_position - creature.global_position).length()
		current_nav_goal = player_last_seen
	else:
		if vision_area.has_overlapping_areas() :
			#print("player close")
			var _p = vision_area.get_overlapping_areas()[0].parent
			var to_player = (_p.global_position - creature.global_position)
			var close = to_player.length_squared() < 4.0
			var loud = !_p.crouching && _p.velocity.length_squared() > 0.01
			var hit = creature.aware
			if close || loud || hit:
				player = _p
			elif (creature.global_basis * Vector3.FORWARD).angle_to(to_player) < deg_to_rad(vision_angle) :
				var space_state = creature.get_world_3d().direct_space_state
				var ray_params = PhysicsRayQueryParameters3D.create(eyes.global_position, _p.global_position + Vector3.UP, 17)
				ray_params.collide_with_areas = true
				var result = space_state.intersect_ray(ray_params)
				if result["collider"].collision_layer == 16 :
					creature.aware = true
					player = _p
	mut.unlock()
	
	var goal_temp = (nav.get_next_path_position() - creature.global_position) * Vector3(1,0,1)
	goal_temp = goal_temp.normalized() * creature.speed
	if !safe_velocity_lockout:
		nav.set_velocity(goal_temp)
		safe_velocity_lockout = true
	creature.goal_vel = goal_vel
	if creature.current_state == Creature.State.WALK :
		creature.goal_look = goal_vel
	elif player != null :
		creature.goal_look = player.global_position - creature.global_position
	
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
					#print("player null, waiting, setting to idle")
					next_state = Creature.State.IDLE
				else:
					#print("player null, not waiting, setting to walk")
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
			if picked_attack > -1 && attack_timer <= 0.0:
				next_state = Creature.State.ATTACK_0 + picked_attack
				attack_timer = attacks[picked_attack].wind_down
				
			elif creature.current_state < Creature.State.ATTACK_0:
				if creature.landed:
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
			var v = Vector3(randf(),randf() * 0.5,randf()).normalized()
			var r = ease(randf(), 0.4) * wander_range
			v *= r
			final = NavigationServer3D.map_get_closest_point(creature.get_world_3d().navigation_map, home + v)
		else:
			break
		
	return final
	
func look_for(_player : Player) -> bool:
	
	return true

func _on_link_reached(details):
	var link : NavigationLink3D = details["owner"]
	if link.navigation_layers > 63:
		next_state = Creature.State.JUMP
		creature.landed = false
		creature.jump_target =  details["link_exit_position"]
		
		
func _on_velocity_computed(vel : Vector3):
	goal_vel = vel
	safe_velocity_lockout = false
	
func _on_path_changed() :
	if !nav.is_target_reachable() && player == null:
		mut.lock()
		current_nav_goal = creature.global_position
		mut.unlock()
	
func _exit_tree():
	mut.lock()
	exit_ai_loop = true
	mut.unlock()
	sem.post()
	ai_loop.wait_to_finish()
	if waiting_thread.is_alive():
		waiting_thread.wait_to_finish()


