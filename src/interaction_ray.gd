extends RayCast3D


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if is_colliding():
		print(get_collider())

func _input(event):
	if event is InputEventMouseButton:
		var targetCollider = get_collider()
		if targetCollider is Interactable:
			targetCollider.interact.emit()
			
