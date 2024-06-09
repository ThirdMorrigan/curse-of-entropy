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
@export var generate_link : bool
@export var roofless : bool
var target_angle
signal finished_opening

var closed_angle : float

var link : NavigationLink3D

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
	generate_link = properties["generate_link"]
	roofless = properties["roofless"]
	setup_link()
	setup_interact()

func setup_link():
	if generate_link:
		print("generating link")
		var bbox : AABB = find_child("*_mesh_*").mesh.get_aabb()
		var forward = openable_from
		if forward :
			forward = forward.normalized()
		else :
			if bbox.get_shortest_axis_index() == Vector3.AXIS_Y:
				forward = Vector3(1,0,1) - bbox.get_longest_axis()
			else :
				forward = bbox.get_shortest_axis()
		link = NavigationLink3D.new()
		link.enabled = false
		var h = bbox.size.y if !roofless else 1000000.0
		var w = max(bbox.size.z, bbox.size.x)
		if h > 2.5 && w > 0.85*2:
			link.navigation_layers = 0b111
		elif h > 1.2+0.8 && w > 1.0:
			link.navigation_layers = 0b11
		else:
			link.navigation_layers = 0b1
		add_child(link)
		link.position = bbox.get_center()
		link.position.y = bbox.position.y
		link.start_position = forward
		link.end_position = -forward
		link.top_level = true

func setup_interact():
	print("setting up")
	var _int = BrushDoorInteractible.new()
	add_child(_int)
	var _prop_dict = {"key":key, "state":state}
	_int._func_godot_apply_properties(_prop_dict)
	var _action = BrushDoorAction.new()
	_int.link = link
	link = null
	_int.add_child(_action)
	var _shapes = find_children("*", "CollisionShape3D")
	if interactable :
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
	setup_link()
	setup_interact()
	if remote_activation_group != "":
		add_to_group(remote_activation_group)
	target_angle = open_angle
	pass

func start_opening():
	swinging = true

func activate():
	start_opening()
