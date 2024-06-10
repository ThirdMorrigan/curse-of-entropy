@tool

extends Area3D

class_name FuncDamage

@export var func_godot_properties : Dictionary

@export var damage : float
@export var interval : float

var timer : float = 0
var _d_i : DamageInstance

func _func_godot_apply_properties(properties: Dictionary) -> void:
	damage = properties["damage"]
	interval = properties["interval"]

func _ready():
	_d_i = DamageInstance.new()
	_d_i.impulse = 0
	_d_i.damage = damage
	_d_i.damage_types = 0b0 + DamageInstance.DamageType.PHYSICAL

func _physics_process(delta):
	if !Engine.is_editor_hint():
		if has_overlapping_areas():
			timer += delta
			if timer >= interval:
				var bodies = get_overlapping_areas()
				for h in bodies:
					if h is Hurtbox:
						h.damage(_d_i)
				timer = 0
		else :
			timer = 0
