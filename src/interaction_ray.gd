extends RayCast3D

var current_interactable : Interactable:
	get:
		return current_interactable
	set(i):
		current_interactable = i
		if current_interactable != null:
			interactable_target_changed.emit(current_interactable.interactionText)
		else:
			interactable_target_changed.emit("")

signal interactable_target_changed

func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var targetCollider = get_collider()
	if current_interactable != targetCollider:
		current_interactable = targetCollider
	elif current_interactable == null and targetCollider == null:
		current_interactable = null

func _input(event):
	if event.is_action_pressed("interact"):
		if current_interactable is Interactable:
			current_interactable.interact.emit()
			
			
