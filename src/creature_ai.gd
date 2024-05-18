extends Node

class_name CreatureAI

var creature : Creature
var nav : NavigationAgent3D

var attack_range : Area3D
var vision_range : Area3D

var pathfind_goal : Vector3 = Vector3.ZERO

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
	nav.target_position = pathfind_goal
	creature.current_state = Creature.State.WALK
	
	set_physics_process(false)
	await get_tree().physics_frame
	await get_tree().physics_frame
	set_physics_process(true)			# this just avoids an error :3
	
func _physics_process(delta):
	if creature.current_state == Creature.State.DIE:
		nav.queue_free()
		attack_range.queue_free()
		vision_range.queue_free()
		queue_free()
	var goal_temp = (nav.get_next_path_position() - creature.global_position) * Vector3(1,0,1)
	goal_temp = goal_temp.normalized()
	creature.goal_vec = goal_temp

func _on_target_reached():
	creature.current_state = Creature.State.IDLE
