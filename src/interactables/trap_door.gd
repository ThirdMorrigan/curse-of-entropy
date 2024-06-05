@tool
extends StaticBody3D


@onready var animation_player = $AnimationPlayer
@export var func_godot_properties : Dictionary
@export var open : bool = false
@export var group : String

func _ready():
	print(group)
	print("group")
	add_to_group(group)

func _func_godot_apply_properties(props: Dictionary) -> void:
	group = props["group"]
	
	open = props["open"]
	if open:
		animation_player.play("open")

func activate():
	print("trap door")
	if open:
		animation_player.play_backwards("open")
	else:
		animation_player.play("open")
	open = !open
