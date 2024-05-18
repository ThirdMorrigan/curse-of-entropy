extends Node

class_name HealthPool

@export var max_hp : float = 10

@export var hurtboxes : Array[Hurtbox]

@onready var parent = $".."

var curr_hp : float

func _ready():
	curr_hp = max_hp
	if hurtboxes == null:			# bind hurtboxes
		queue_free()
	else : 
		for h in hurtboxes:
			h.health_pool = self
		hurtboxes = []				# decouple

func hurt(di : DamageInstance):
	curr_hp -= di.damage
	if curr_hp < 0.0 :
		pass
