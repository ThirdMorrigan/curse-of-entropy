extends RangedAttack

class_name GrappleHook

var firing : bool = false
var reeling : bool = false

var cable_visuals : Node3D

func _ready():
	hit.connect(_on_hit)
	$"..".grapple_disconnect.connect(_on_grapple_disconnect)
	super()
	cable_visuals = visuals.instantiate()
	if visuals != null :
		attack_origin.add_child(cable_visuals)
		cable_visuals.position = Vector3.ZERO
		cable_visuals.rotation = Vector3.ZERO
		cable_visuals.visible = false

func _create_hitbox():
	var h = super()
	h.collision_mask = 0b10000011
	h.max_distance = ai_range_max
	h.free.connect(_on_free)
	h.timer_length = -1
	return h

func _physics_process(delta):
	if firing && cast == null:
		firing = false
	elif cast != null && !cable_visuals.global_position.is_equal_approx(cast.global_position) :
		cable_visuals.look_at(cast.global_position)
		cable_visuals.scale.z = (cast.global_position - attack_origin.global_position).length()
		

func fire():
	cast.collide_with_bodies = true
	if !(firing || reeling) :
		cast.set_movement_vector((attack_origin.global_basis * Vector3.FORWARD), attack_range)
		cast.global_rotation = Vector3.ZERO
		cast.travelling = true
		cast.top_level = true
		cable_visuals.visible = true
		firing = true
		

func _on_hit():
	firing = false
	var hit_target = cast.object_hit
	print(hit_target)
	
	if hit_target is GrappleTarget:
		reeling = true
		$"..".start_grapple(hit_target)

func _on_grapple_disconnect():
	cast._on_timer_timeout()
	reeling = false
	cable_visuals.visible = false

func _on_free():
	firing = false
	reeling = false
	cable_visuals.visible = false
	create_hitbox()
