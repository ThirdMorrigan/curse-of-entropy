extends Attack

class_name SwordAttack

func _process(_delta):
	cast.global_transform = attack_origin.global_transform
	
func fire() -> Array[Hurtbox] :
	var hits : Array[Hurtbox] = []
	cast.force_shapecast_update()
	if cast.is_colliding():
		for t in range(cast.get_collision_count()):
			var h = cast.get_collider(t)
			if h is Hurtbox:
				hit.emit()
				hits.append(h)
	
	return hits
