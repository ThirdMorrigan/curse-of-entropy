extends Area3D

const INVENTROY = preload("res://_PROTO_/inventroy.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	if INVENTROY.bagHasByID(8,2):
		area.startClimb()


func _on_area_exited(area):
	if INVENTROY.bagHasByID(8,2):
		area.stopClimb()
