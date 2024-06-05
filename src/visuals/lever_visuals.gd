extends Node3D

@onready var animation_player = $AnimationPlayer

func play(reverse):
	if reverse:
		animation_player.play_backwards("pull")
	else:
		animation_player.play("pull")
