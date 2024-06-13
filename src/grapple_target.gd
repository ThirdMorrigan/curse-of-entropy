extends Area3D

class_name GrappleTarget

# Called when the node enters the scene tree for the first time.
func _ready():
	collision_layer = 0b10000000
