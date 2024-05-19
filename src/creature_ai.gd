extends Node

class_name CreatureAI

@export var wander_range : float = 10
@export var wander_wait_min : float = 1.0
@export var wander_wait_max : float = 8.0
@export var ai_tickrate : int = 4

var creature : Creature
var nav : NavigationAgent3D

var wander_goal : Vector3 = Vector3.ZERO

var player : Player
var player_last_seen : Vector3

var exit_ai_loop : bool = false
@onready var mut : Mutex = Mutex.new()
@onready var sem : Semaphore = Semaphore.new()
@onready var ai_loop : Thread = Thread.new()
var ai_ticker : int 
var waiting : bool
@onready var waiting_thread : Thread = Thread.new()

var next_state : Creature.State

var home : Vector3

func _ready():
	if $".." is Creature :
		creature = $".."
	else :
		queue_free()
	nav = creature.find_children("*", "NavigationAgent3D")[0]
	if !(nav is NavigationAgent3D):
		print("dies xd")
		queue_free()
		
	nav.target_reached.connect(_on_target_reached)
	nav.target_position = wander_goal
	creature.current_state = Creature.State.IDLE
	
	home = creature.global_position
	
	set_physics_process(false)
	await get_tree().physics_frame
	await get_tree().physics_frame
	set_physics_process(true)			# this just avoids an error :3
	
	ai_loop.start(_ai_loop)
	
func _physics_process(_delta):
	if creature.current_state == Creature.State.DIE:
		nav.queue_free()
		queue_free()
		
	if player == null :
		pass
	
	if !ai_ticker:
		sem.post()
		ai_ticker += ai_tickrate
	ai_ticker -= 1
	
	mut.lock()
	creature.current_state = next_state
	mut.unlock()
	
	var goal_temp = (nav.get_next_path_position() - creature.global_position) * Vector3(1,0,1)
	goal_temp = goal_temp.normalized()
	creature.goal_vec = goal_temp

func _on_target_reached():
	if player == null :
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
			if waiting:
				next_state = Creature.State.IDLE
				mut.unlock()
			else:
				next_state = Creature.State.WALK
				if nav.target_position != wander_goal:
					nav.target_position = wander_goal
				mut.unlock()
		else:
			pass
	
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
	randomize()
	var v = Vector3(randf(),randf(),randf()).normalized()
	var r = ease(randf(), 0.4) * wander_range
	v *= r
	return NavigationServer3D.map_get_closest_point(creature.get_world_3d().navigation_map, home + v)
	
func _exit_tree():
	mut.lock()
	exit_ai_loop = true
	mut.unlock()
	sem.post()
	ai_loop.wait_to_finish()
	waiting_thread.wait_to_finish()
