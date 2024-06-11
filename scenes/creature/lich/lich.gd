extends Node3D

class_name Lich

@export var anim_tree : AnimationTree

@export var shielded : bool = true :
	get:
		return shielded
	set(s):
		shielded = s
		$metarig/Skeleton3D/Cube.get_surface_override_material(0).set("hide", s)
		$HealthPool.immunities = 0b11111 if s else 0b11101
		
var player : Player :
	get :
		return player
	set(p) :
		player = p
		if anim_tree != null:
			anim_tree.player = player

var process : bool


var alpha : float = 0
var attack_timer : float = 3.0
var current_attack : Attack

func wake():
	$metarig.visible = true
	$spawn.emitting = true
	anim_tree.wake = true
	

# Called when the node enters the scene tree for the first time.
func _ready():
	$metarig.visible = false
	process = false
	$player_check.area_entered.connect(_on_area_entered)
	anim_tree.animation_finished.connect(_on_animation_finished)
	anim_tree.fire.connect(_on_fire)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if process:
		attack_timer -= delta
		var to_player = player.global_position - global_position
		global_rotation.y = atan2(player.global_position.x, player.global_position.z)
		if attack_timer <= 0.0 && current_attack == null:
			if to_player.length_squared() > 3.5 * 3.5:
				anim_tree.attack_horizontal = true
			else :
				anim_tree.attack_cast = true
	

func _on_area_entered(hb : Area3D):
	if hb is Hurtbox :
		if hb.parent is Player :
			if player == null :
				player = hb.parent
	
func _on_animation_finished(anim_name : String):
	anim_name = anim_name.to_upper()
	if anim_name.contains("spawn"):
		process = true
	elif anim_name.contains("attack"):
		current_attack = null

func _on_fire():
	current_attack.fire()
	attack_timer = current_attack.wind_down

func die():
	pass
