extends StaticBody3D

class_name FuncArcaneLock

var shapes : Array[CollisionShape3D] = []
# Called when the node enters the scene tree for the first time.
func _ready():
	var _shapes = find_children("*", "CollisionShape3D")
	for _s in _shapes :
		if _s is CollisionShape3D :
			shapes.append(_s)
	
	var hp : HealthPool = HealthPool.new()
	var hb : Hurtbox = Hurtbox.new()
	hp.max_hp = 1
	hp.immunities = 2
	hp.invert_immunities = true
	hb.copy_collision_shapes = shapes
	hb.collision_layer = 0b1000
	add_child(hp)
	add_child(hb)
	hp.hurtboxes = [ hb ]
	hb.reset()
	hp.reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func die():
	
	queue_free()
