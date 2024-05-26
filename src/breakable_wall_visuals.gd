extends Node3D

@onready var animation_player = $AnimationPlayer

signal broken

func breakWall():
	animation_player.play("Animation")


func _on_animation_player_animation_finished(anim_name):
	broken.emit()
