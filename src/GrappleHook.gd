extends RangedAttack

class_name GrappleHook

var firing : bool = false
var reeling : bool = false

func _ready():
	hit.connect(_on_hit)
	$"..".grapple_disconnect.connect(_on_grapple_disconnect)
	super()

func _create_hitbox():
	var h = super()
	h.collision_mask = 0b10000011
	h.max_distance = ai_range_max
	h.free.connect(_on_free)
	return h

func _physics_process(delta):
	if firing && cast == null:
		firing = false

func fire():
	if !(firing || reeling) :
		cast.set_movement_vector((attack_origin.global_basis * Vector3.FORWARD), attack_range)
		cast.global_rotation = Vector3.ZERO
		var _vis = visuals.instantiate()
		if visuals != null :
			cast.add_child(_vis)
			_vis.position = Vector3.ZERO
			_vis.global_basis = attack_origin.global_basis
		cast.travelling = true
		cast.top_level = true
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

func _on_free():
	firing = false
	reeling = false
	create_hitbox()
