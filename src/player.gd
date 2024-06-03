@tool
extends CharacterBody3D

class_name Player

@export var speed : float = 3
@export var speed_crouch : float
@export var acceleration : float
@export var acceleration_air : float
@export var friction : float
@export var jump_height : float = 0.0 :
	get:
		return jump_height
	set(h):
		jump_height = h
		jump_power = sqrt(-(2 * -9.81 * h))
		notify_property_list_changed()
@export var crouch_difference : float = 0.5 :
	get:
		return crouch_difference
	set(a):
		if Engine.is_editor_hint():
			crouch_difference = $standing_camera_pos.position.y - $crouching_camera_pos.position.y
		else : crouch_difference = a
		notify_property_list_changed()
@export var crouchjump_height : float = 0.0 :
	get:
		return jump_height + crouch_difference
	set(h):
		jump_height = h - crouch_difference
		notify_property_list_changed()
@export var coyote_frames : int = 6

@export var sword_swing : Attack
@export var current_swing_damage_instance : int = 0
@export var swinging : bool = false

@export var current_tool : Attack
@onready var inventory = preload("res://_PROTO_/inventroy.tres")

signal player_death

var jump_power : float
var climbing : bool = false
var coyote_timer : int
var crouching : bool :
	get:
		return crouching
	set(c):
		if !$direction_pivot/uncrouch.is_colliding() || c :
			crouching = c
			$body_standing.disabled = c
			$Hurtbox/hurtbox_standing.disabled = c
			$body_crouching.disabled = !c
			$Hurtbox/hurtbox_crouching.disabled = !c
			camera_lerp = $crouching_camera_pos if c else $standing_camera_pos
			try_uncrouch = false
		elif !c :
			try_uncrouch = true
var try_uncrouch : bool = false
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
var character : PlayerCharacter
var input_dir : Vector3 = Vector3.ZERO
var can_jump : bool
var jumping : bool :
	get:
		return jumping
	set(j):
		if j && can_jump && coyote_timer :
			jump()
		jumping = j
		

func _ready():
	inventory.jump_boots.connect(_apply_jump_boots)
	crouching = false
	character = PlayerCharacter.new()
	add_child(character)

func _process(delta):
	if !Engine.is_editor_hint():
		if $camera_pivot.position.y != camera_lerp.position.y:
			var vert_move = move_toward($camera_pivot.position.y, camera_lerp.position.y, delta * 4) - $camera_pivot.position.y
			$camera_pivot.position.y += vert_move
			position.y -= vert_move
		if try_uncrouch :
			crouching = false

func _physics_process(delta):
	if !Engine.is_editor_hint():
		var floor_friction : float = 1.0
		if $floor_test.is_colliding() :
			var col = $floor_test.get_collider()
			if col is StaticBody3D or col is RigidBody3D:
				var pmo = col.physics_material_override
				if pmo != null:
					floor_friction = pmo.friction
					#print(floor_friction)
		
		if not is_on_floor():
			if !climbing:
				velocity.y -= gravity * delta
				if coyote_timer :
					coyote_timer-=1
		else : 
			coyote_timer = coyote_frames * int(!jumping)
			can_jump = !jumping
			
		var vel_v = velocity.y
		velocity.y = 0
		var edge_stop = !$direction_pivot/leading_ray.is_colliding() && !input_dir
		var temp_friction = friction
		temp_friction *= (2 if edge_stop else 1)
		temp_friction *= floor_friction
		velocity *= 1 - (delta * temp_friction * float(is_on_floor()))
			
		velocity += input_dir * delta * ((acceleration*floor_friction) if is_on_floor() else acceleration_air)
		var speed_limit := speed if !crouching || !is_on_floor() else speed_crouch
		if swinging : speed_limit *= sword_swing.weight
		velocity = velocity.limit_length(speed_limit)

		if !climbing:
			velocity.y = vel_v
		else:
			velocity.y = jump_power
			velocity.x = 0
			velocity.z = 0

		move_and_slide()
		
		$direction_pivot.global_rotation.y = atan2(-velocity.x, -velocity.z)

func try_swing():
	if !swinging:
		#more shit in here!!!!!
		swinging = true

func impulse(i : Vector3):
	velocity = i

func jump():
	velocity.y += jump_power

func _apply_jump_boots():
	jump_height = 1

func die():
	var death_chance = character.get_death_chance()
	player_death.emit(randf_range(0,100) < death_chance)
	get_tree().call_group("creature","stop")
	



func _on_game_ui_fade_complete():
	position = GameDataSingleton.respawn_point
	get_tree().call_group("creature","delete")
	get_tree().call_group("spawner","spawn")
	character.get_older()
	
