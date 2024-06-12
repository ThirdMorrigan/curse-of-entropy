extends Node

class_name PlayerInputHandler

@onready var player : Player = $".."
@onready var inventory = load("res://_PROTO_/inventroy.tres")
var lockMouse : bool = false
var mouselook_active : bool :
	get:
		return mouselook_active
	set(b):
		mouselook_active = b
		if b :
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else :
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _ready():
	mouselook_active = true

func _input(event):
	if event is InputEventMouseMotion && mouselook_active && not lockMouse:
		player.yaw -= event.relative.x * 0.001
		player.pitch_camera -= event.relative.y * 0.001

func _process(_delta):
	var input = Input.get_vector("move_l","move_r","move_f","move_b")
	var input3 = player.basis * Vector3(input.x, 0.0, input.y)
	player.input_dir = input3
	if Input.is_action_just_pressed("move_jump") or Input.is_action_just_released("move_jump"):
		player.jumping = Input.is_action_pressed("move_jump")
	if Input.is_action_just_pressed("crouch") or Input.is_action_just_released("crouch"):
		player.crouching = Input.is_action_pressed("crouch")
	if Input.is_action_just_pressed("swing"):
		player.try_swing()
		

func _physics_process(delta):
	if Input.is_action_just_pressed("cycle_tool_up"):
		player.cycle_current_tool(-1)
	if Input.is_action_just_pressed("cycle_tool_down"):
		player.cycle_current_tool(1)
	if Input.is_action_just_pressed("use_tool"):
		if player.current_tool != null:
			if player.current_tool.check():
				player.current_tool.fire()
	if Input.is_action_just_pressed("cycle_consumeable"):
		player.cycle_consumeable()
	if Input.is_action_just_pressed("use_consumeable"):
		player.use_consumeable()


func _on_inventory_ui_inventory_state_change(state):
	lockMouse = state


func _on_player_pause_player():
	set_process(false)
	set_physics_process(false)


func _on_player_unpause_player():
	set_process(true)
	set_physics_process(true)
