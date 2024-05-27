extends StaticBody3D
class_name BreakableWall

@onready var breakable_wall_visuals = $breakable_wall_visuals
@onready var collision_shape_3d = $CollisionShape3D
@onready var hurtbox = $Hurtbox

signal opened

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func die():
	breakable_wall_visuals.breakWall()
	collision_shape_3d.queue_free()
	hurtbox.queue_free()
	reparent($"../../..")
	


func _on_wall_broken():
	#breakable_wall_visuals.queue_free()
	opened.emit()
