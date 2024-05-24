extends StaticBody3D

@onready var breakable_wall_visuals = $breakable_wall_v5
@onready var collision_shape_3d = $CollisionShape3D
@onready var hurtbox = $Hurtbox

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func die():
	var inventory = load("res://_PROTO_/inventroy.tres")
	inventory.consumeItem(3)
	breakable_wall_visuals.breakWall()
	collision_shape_3d.queue_free()
	hurtbox.queue_free()
