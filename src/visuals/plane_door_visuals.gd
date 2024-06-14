@tool
extends Node3D

@export var material : ShaderMaterial:
	get:
		return material
	set(m):
		material = m
		_apply_material()


func _apply_material():
	##print("here")
	for mesh : MeshInstance3D in get_children():
		##print("for the kds")
		mesh.set_surface_override_material(0,material)
