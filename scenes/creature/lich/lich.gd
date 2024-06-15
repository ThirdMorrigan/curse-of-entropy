extends Node3D

class_name Lich

@export var anim_tree : AnimationTree

@export var shielded : bool = true :
	get:
		return shielded
	set(s):
		shielded = s
		$metarig/Skeleton3D/Cube.get_surface_override_material(0).set("shader_parameter/hide", !s)
		$HealthPool.immunities = 0b11111 if s else 0b0
		$sheild/Hurtbox.monitorable = s
		
var player : Player :
	get :
		return player
	set(p) :
		player = p
		if anim_tree != null:
			anim_tree.player = player

signal victory

var process : bool


var alpha : float = 0
var attack_timer : float = 3.0
var current_attack : Attack

func wake():
	$metarig.visible = true
	$spawn.emitting = true
	anim_tree.reset = false
	anim_tree.wake = true
	shielded = true
	$Hurtbox.monitorable = true
	

# Called when the node enters the scene tree for the first time.
func _ready():
	shielded = false
	$metarig.visible = false
	process = false
	$player_check.area_entered.connect(_on_area_entered)
	anim_tree.animation_finished.connect(_on_animation_finished)
	anim_tree.fire.connect(_on_fire)
	$Hurtbox.monitorable = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if process:
		scale = Vector3(2.0,2.0,2.0)
		attack_timer -= delta
		var to_player = player.global_position - global_position
		global_rotation.y = lerp_angle(global_rotation.y, atan2(-to_player.x, -to_player.z), delta * 2.0)
		if attack_timer <= 0.0 && current_attack == null:
			print(to_player.length())
			if to_player.length_squared() < 6 * 6:
				anim_tree.attack_horizontal = true
				current_attack = $swing_horizontal
			else :
				anim_tree.attack_cast = true
				current_attack = $magic_cast
		scale = Vector3(2.0,2.0,2.0)
	

func _on_area_entered(hb : Area3D):
	if hb is Hurtbox :
		if hb.parent is Player :
			if player == null :
				player = hb.parent
	
func _on_animation_finished(anim_name : String):
	anim_name = anim_name.to_upper()
	if anim_name.contains("SPAWN"):
		process = true
	elif anim_name.contains("ATTACK"):
		
		current_attack = null
	elif anim_tree.contains("SPAWN") && anim_tree.dying:
		print("wawa")
		victory.emit()

func _on_fire():
	current_attack.fire()
	attack_timer = current_attack.wind_down

func die():
	print("epic win!!!!")
	process = false
	anim_tree.dying = true
	#queue_free()

func stop():
	process = false

func delete():
	shielded = false
	process = false
	attack_timer = 3.0
	anim_tree.reset = true
	$metarig.visible = false
	$Hurtbox.monitorable = false
	
