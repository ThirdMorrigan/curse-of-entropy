extends Node
class_name AnimationController

@onready var creature = $".."
@onready var animation_player = $"../AnimationPlayer"


# Called when the node enters the scene tree for the first time.
func _ready():a
	animation_player.play("walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass