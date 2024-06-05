extends Node3D

@onready var animation_player = $AnimationPlayer

func play():
	animation_player.play("pull")
