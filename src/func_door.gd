@tool
extends AnimatableBody3D

class_name FuncDoor

@export var func_godot_properties : Dictionary

@export var axis : int = 1
@export var open_angle : float
@export var speed : float
@export var interactable : bool
@export var key : int
@export var state : int
@export var openable_from : Vector3
@export var remote_activation_group : String
var target_angle
signal finished_opening

var closed_angle : float

var swinging : bool = false

func _func_godot_apply_properties(properties: Dictionary) -> void:
	axis = properties["axis"].max_axis_index()
	open_angle = deg_to_rad(properties["open_angle"])
	speed = properties["speed"]
	interactable = properties["interactable"]
	print(str(properties["interactable"]), " in apply")
	key = properties["key"]
	state = properties["state"]
	remote_activation_group = properties["remote_activation_group"]
	var f = properties["openable_from"]
	openable_from = Vector3(f.y, f.z, f.x)
	setup_interact()

func setup_interact():
	if interactable :
		print("setting up")
		var _int = BrushDoorInteractible.new()
		add_child(_int)
		var _prop_dict = {"key":key, "state":state}
		_int._func_godot_apply_properties(_prop_dict)
		var _action = BrushDoorAction.new()
		_int.add_child(_action)
		var _shapes = find_children("*", "CollisionShape3D")
		for _s in _shapes :
			var _int_coll = CollisionShape3D.new()
			_int_coll.shape = _s.shape
			_int.add_child(_int_coll)

func _physics_process(delta):
	if swinging :
		rotation[axis] = move_toward(rotation[axis], target_angle, speed * delta)
		if is_equal_approx(rotation[axis],target_angle):
			swinging = false
			finished_opening.emit()
			if target_angle != 0:
				target_angle = 0
			else:
				target_angle = open_angle

func _ready():
	#print(interactable)
	setup_interact()
	if remote_activation_group != "":
		add_to_group(remote_activation_group)
	target_angle = open_angle
	pass

func start_opening():
	swinging = true

func activate():
	start_opening()
