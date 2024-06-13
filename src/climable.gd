extends Area3D

const INVENTROY = preload("res://_PROTO_/inventroy.tres")


func _on_area_entered(area):
	if INVENTROY.bagHasByID(8,2):
		area.startClimb()


func _on_area_exited(area):
	if INVENTROY.bagHasByID(8,2):
		area.stopClimb()
