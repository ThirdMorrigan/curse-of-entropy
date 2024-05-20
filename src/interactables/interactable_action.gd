extends Node
class_name InteractableAction

@onready var interactable = $".."

# Called when the node enters the scene tree for the first time.
func _ready():
	if interactable is Interactable:
		interactable.interact.connect(_on_interact)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_interact():
	print("no action implamented")
