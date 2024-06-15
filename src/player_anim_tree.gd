extends AnimationTree

@export var swinging : bool :
	get:
		if player != null :
			return player.swinging
		else : return false
@export var fire_attack : bool = false :
	set(f):
		fire_attack = f
		if !f :
			attack_closeout()

var character_details : PlayerCharacter
var player : Player
var current_state : Creature.State
var has_hit : Array[HealthPool] = []
var damage_mults : Array[float] = []

var relative_velocity : Vector3 = Vector3.ZERO

signal attack_finished

func _ready():
	player = $".."
	fire_attack = false
	animation_finished.connect(_on_animation_finished)
	

func _physics_process(delta):
	relative_velocity = player.velocity * player.global_basis
	relative_velocity.y = 0.0
	var blend_pos = get("parameters/walk/tilt_blend_space/blend_position")
	blend_pos = lerp(blend_pos, relative_velocity.x / 3.0, delta * 6.0)
	set("parameters/walk/tilt_blend_space/blend_position", blend_pos)
	##print(relative_velocity)
	if fire_attack :
		var new_hits : Array[Hurtbox] = player.sword_swing.fire()
		for h in range(new_hits.size()) :
			if has_hit.has(new_hits[h].health_pool):
				var pool_index : int = has_hit.find(new_hits[h].health_pool)
				damage_mults[pool_index] = max(damage_mults[pool_index], new_hits[h].damage_modifier) if (damage_mults[pool_index] && new_hits[h].damage_modifier) else 0.0
			else :
				has_hit.append(new_hits[h].health_pool)
				damage_mults.append(new_hits[h].damage_modifier)
	else:
		
		pass

func attack_closeout():
	if has_hit != [] :
		for h in range(has_hit.size()):
			var d : DamageInstance = player.sword_swing.damage_instances[player.current_swing_damage_instance].copy()
			d.impulse *= damage_mults[h]
			d.rotate_impulse(player.global_basis)
			if character_details != null:
				d.damage += character_details.strength * 0.02
			d.damage *= damage_mults[h]
			
			
			has_hit[h].hurt(d)
		has_hit = []
		damage_mults = []

func _on_animation_finished(anim_name : String):
	anim_name = anim_name.to_upper()
	if anim_name.begins_with("SWING"):
		attack_finished.emit()
		player.swinging = false

func fire_current_attack():
	##print("trying to fire")
	pass
