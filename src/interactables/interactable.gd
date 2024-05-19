extends Area3D
class_name Interactable

@export var objectName : String = "default name"
signal interact
func _ready():
	collision_layer = 4


func interacted():
	interact.emit()
