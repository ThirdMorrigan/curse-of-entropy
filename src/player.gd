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
@export var tool_attacks : Array[Attack]
var current_tool : Attack
var current_consumeable : int
@onready var inventory = preload("res://_PROTO_/inventroy.tres")
@onready var game_ui = $game_ui
@onready var fireball = $Fireball
@onready var pickaxe_swing = $PickaxeSwing
@onready var arcane_spell = $ArcaneSpell

signal player_death
signal pause_player
signal unpause_player
signal mana_changed
signal grapple_disconnect
var current_max_speed : float

var max_mana : float = 100
var curr_mana : float = max_mana:
	get:
		return curr_mana
	set(m):
		curr_mana = m
		mana_changed.emit(curr_mana,max_mana)

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

var grappling : bool = false
var grapple_dc_ticker : int = 0
var grapple_target : Node3D


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
	#print("new players")
	current_max_speed = speed
	inventory.jump_boots.connect(_apply_jump_boots)
	inventory.fireball.connect(_add_fireball)
	inventory.pickaxe.connect(_add_pickaxe)
	inventory.arcane.connect(_add_arcane)
	inventory.setup_tools()
	crouching = false
	character = PlayerCharacter.new()
	add_child(character)
	character.connect_player()
	if not tool_attacks.is_empty():
		current_tool = tool_attacks[0]
	#curr_mana = max_mana
	if inventory.bags[GameDataSingleton.item_types.CONSUMABLE].is_empty():
		inventory.add(6,3)
		
	cycle_consumeable()

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
		if !grappling :
			var floor_friction : float = 1.0
			if $floor_test.is_colliding() :
				var col = $floor_test.get_collider()
				if col is StaticBody3D or col is RigidBody3D:
					var pmo = col.physics_material_override
					if pmo != null:
						floor_friction = pmo.friction
						#print(floor_friction)
				elif col is Creature:
					floor_friction = 0
					velocity += Vector3.FORWARD* 100
			$mantle_fix_c.disabled = is_on_floor()
			$mantle_fix_l.disabled = is_on_floor()
			$mantle_fix_r.disabled = is_on_floor()
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
			if swinging :
				speed_limit *= sword_swing.weight + (character.strength-100) * 0.002
				#print(sword_swing.weight + (character.strength-100) * 0.002)
			current_max_speed = lerp(current_max_speed, speed_limit, delta * 5.0)
			velocity = velocity.limit_length(current_max_speed)

			if !climbing:
				velocity.y = vel_v
			else:
				velocity.y = jump_power
				velocity.x = 0
				velocity.z = 0

			move_and_slide()
		else :
			var to_target = grapple_target.global_position - $camera_pivot/Camera3D/attack_origin.global_position
			var to_target_n = to_target.normalized()
			velocity = to_target_n * 3.0
			print("wawa")
			var pre = global_position
			move_and_slide()
			var post = global_position
			
			if (pre - post).length_squared() < 0.1:
				grapple_dc_ticker += 1
			else :
				grapple_dc_ticker = 0
			
			var dc :bool= (grapple_target.global_position -
				$camera_pivot/Camera3D/attack_origin.global_position).length_squared() < 0.001
			
			print(dc)
			if dc :
				grappling = false
				grapple_disconnect.emit()
			
		$direction_pivot.global_rotation.y = atan2(-velocity.x, -velocity.z)

func start_grapple(target : Node3D):
	print("wawawa")
	grappling = true
	grapple_target = target
	pass

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

func _add_fireball():
	if not (fireball in tool_attacks):
		tool_attacks.append(fireball)

func _add_pickaxe():
	if not (pickaxe_swing in tool_attacks):
		tool_attacks.append(pickaxe_swing)

func _add_arcane():
	if not (pickaxe_swing in tool_attacks):
		tool_attacks.append(arcane_spell)
		


func die():
	get_tree().call_group("creature","stop")
	pause()
	if character != null:
		var death_chance = character.get_death_chance()
		player_death.emit(randf_range(0,100) < death_chance)
	
	

func pause():
	pause_player.emit()
	set_process(false)
	set_physics_process(false)

func unpause():
	set_process(true)
	set_physics_process(true)
	unpause_player.emit()


func _on_game_ui_fade_complete():
	position = GameDataSingleton.respawn_point
	get_tree().call_group("creature","delete")
	get_tree().call_group("spawner","spawn")
	curr_mana = max_mana
	character.get_older()
	unpause()

func new_character(new_char):
	character = new_char
	character.reparent(self)
	character.connect_player()

func cycle_current_tool(dir : int):
	var size = tool_attacks.size()
	if size:
		var new_index = tool_attacks.find(current_tool) + dir
		if new_index >= size:
			new_index = 0
		elif new_index < 0:
			new_index = size -1
		#print_debug(new_index)
		current_tool = tool_attacks[new_index]
		set_ui_items()

func cycle_consumeable():
	var consumable_array = inventory.bags[GameDataSingleton.item_types.CONSUMABLE].keys()
	#print(consumable_array)
	if consumable_array.size():
		var index = consumable_array.find(current_consumeable)
		if index > -1:
			index += 1
			if index >= consumable_array.size():
				index = 0
		else:
			index = 0
		current_consumeable = consumable_array[index]
	set_ui_items()
	
	

func use_consumeable():
	var item = GameDataSingleton.itemLookupTable[current_consumeable]
	if inventory.playerHas(current_consumeable):
		inventory.consumeItem(current_consumeable)
		set_ui_items()
		match item["resource"]:
			GameDataSingleton.consumeable_type.HEALTH:
				heal_health(item["strength"])
			GameDataSingleton.consumeable_type.MANA:
				heal_mana(item["strength"])
			GameDataSingleton.consumeable_type.STAMINA:
				pass

func set_ui_items():
	var tool_name
	if current_tool != null:
		tool_name = current_tool.display_name
	else:
		tool_name = ""
	game_ui.set_selected_item_text(GameDataSingleton.itemLookupTable[current_consumeable].name,inventory.get_quantity(current_consumeable), tool_name)
	
func heal_health(strength):
	$HealthPool.heal(strength)

func heal_mana(strength):
	curr_mana = minf(max_mana,curr_mana + strength)
	
func _on_spell_fired(cost):
	curr_mana -= cost
