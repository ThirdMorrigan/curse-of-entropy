extends Node

class_name PlayerInputHandler

@onready var player : Player = $".."

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
	if event is InputEventMouseMotion && mouselook_active:
		player.yaw -= event.relative.x * 0.001
		player.pitch_camera -= event.relative.y * 0.001

func _process(delta):
	var input = Input.get_vector("move_l","move_r","move_f","move_b")
	var input3 = player.basis * Vector3(input.x, 0.0, input.y)
	player.input_dir = input3
	if Input.is_action_just_pressed("move_jump") or Input.is_action_just_released("move_jump"):
		player.jumping = Input.is_action_pressed("move_jump")
	if Input.is_action_just_pressed("crouch") or Input.is_action_just_released("crouch"):
		player.crouching = Input.is_action_pressed("crouch")
		


