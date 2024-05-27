@tool
extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer
@export var material : ShaderMaterial:
	get:
		return material
	set(m):
		material = m
		apply_material()

signal broken


func breakWall():
	animation_player.play("Animation")


func _on_animation_player_animation_finished(anim_name):
	broken.emit()
	timer.start()

func _on_timer_timeout():
	print("kill")
	var rock = get_children().pick_random()
	if rock is MeshInstance3D:
		rock.queue_free()
	else:
		if get_children().size() < 3:
			timer.stop()

func apply_material():
	for child in get_children():
		if child is MeshInstance3D:
			for i in child.get_surface_override_material_count():
				child.set_surface_override_material(i,material)
