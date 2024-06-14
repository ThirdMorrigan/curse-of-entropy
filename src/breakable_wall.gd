extends StaticBody3D
class_name BreakableWall

@onready var breakable_wall_visuals = $breakable_wall_visuals
@onready var collision_shape_3d = $CollisionShape3D
@onready var hurtbox = $Hurtbox

signal opened

func die():
	breakable_wall_visuals.breakWall()
	collision_shape_3d.queue_free()
	hurtbox.queue_free()
	var inv = load("res://_PROTO_/inventroy.tres")
	inv.consumeItem(3)
	reparent($"../../..")
	


func _on_wall_broken():
	#breakable_wall_visuals.queue_free()
	opened.emit()
