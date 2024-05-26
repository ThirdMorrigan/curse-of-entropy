extends Area3D
class_name Interactable

@export var objectName : String = "default name"
@export var interactionText : String = "interact"
@export var id : int = 0
@export var quantity : int = 1
signal interact

func _ready():
	_interactable_ready()

func _interactable_ready():
	collision_layer = 4

func interacted():
	interact.emit()
