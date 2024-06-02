extends Node

class_name HealthPool

@export var max_hp : float = 10
@export var max_hp_loss_ration : float = 0.01
@export var hurtboxes : Array[Hurtbox]

var parent :
	set(p):
		parent = p
		can_impulse = parent.has_method("impulse")
		#print(can_impulse)

signal health_change

var can_impulse : bool
var curr_max_hp : float
var curr_hp : float :
	get:
		return curr_hp
	set(hp):
		curr_hp = hp
		health_change.emit(curr_hp)

func _ready():
	curr_max_hp = max_hp
	curr_hp = max_hp
	if hurtboxes == null:			# bind hurtboxes
		queue_free()
	else : 
		for h in hurtboxes:
			h.health_pool = self
		hurtboxes = []				# decouple
	parent = $".."

func hurt(di : DamageInstance):
	curr_hp -= di.damage
	curr_max_hp -= di.damage * max_hp_loss_ration
	if curr_hp <= 0.0 :
		parent.die()
	if can_impulse:
		parent.impulse(di.impulse_vector)
	#print(str("someone's health pool is now ", curr_hp))
	

func heal(healing : float):
	curr_hp = minf(curr_max_hp,curr_hp+healing)


func _on_player_death():
	curr_max_hp = max_hp
	curr_hp = max_hp
