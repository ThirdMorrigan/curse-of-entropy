extends RayCast3D


func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	pass

func _input(event):
	if event.is_action_pressed("interact"):
		var targetCollider = get_collider()
		if targetCollider is Interactable:
			targetCollider.interact.emit()
			
