extends Resource
class_name DamageInstance

enum DamageType {
	PHYSICAL = 1,
	MAGICAL = 2,
	HEAT = 4,
	BLAST = 8,
	PRYBAR = 16
}

@export var damage : float
@export var impulse : float :
	get:
		return impulse_vector.length()
	set(i):
		impulse_vector = Vector3(0,0.45,-0.89) * i
@export_flags("Physical:1","Magical:2","Heat:4","Blast:8","Prybar:16") var damage_types = 0

var impulse_vector : Vector3 :
	set(v):
		if !v.is_normalized():
			v = v.normalized()
		v *= impulse
		impulse_vector = v

func rotate_impulse(b:Basis):
	impulse_vector = b * impulse_vector

func has_type(t : DamageType) -> bool:
	return t&damage_types

func copy() -> DamageInstance:
	var d = DamageInstance.new()
	d.damage = damage
	d.impulse_vector = impulse_vector
	d.damage_types = damage_types
	return d
