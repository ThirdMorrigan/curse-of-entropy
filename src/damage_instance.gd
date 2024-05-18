extends Resource
class_name DamageInstance

@export var damage : float
@export var impulse : float :
	get:
		return impulse_vector.length()
	set(i):
		impulse_vector = Vector3(0,0.45,-0.89) * i

var impulse_vector : Vector3

func rotate_impulse(b:Basis):
	impulse_vector *= b
