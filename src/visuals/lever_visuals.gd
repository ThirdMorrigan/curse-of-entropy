extends Node3D

@onready var animation_player = $AnimationPlayer

func play(reverse):
	if reverse:
		animation_player.play("up")
	else:
		animation_player.play("down")
