extends Node

class_name HealthPool

@export var max_hp : float = 10
@export var max_hp_loss_ration : float = 0.1
@export var hurtboxes : Array[Hurtbox]

@export_flags("Physical:1","Magical:2","Heat:4","Blast:8","Prybar:16") var immunities = 0
@export var invert_immunities : bool = false


var parent :
	set(p):
		parent = p
		can_impulse = parent.has_method("impulse")
		##print(can_impulse)

signal health_change
signal hurted
signal max_health_changed
var can_impulse : bool
var curr_max_hp : float:
	get:
		return curr_max_hp
	set(mhp):
		curr_max_hp = mhp
		max_health_changed.emit(curr_max_hp,max_hp)
var curr_hp : float :
	get:
		return curr_hp
	set(hp):
		curr_hp = hp
		health_change.emit(curr_hp,curr_max_hp)

func _ready():
	if invert_immunities :
		immunities = ~immunities
	reset()

func hurt(di : DamageInstance):
	#print("ouch")
	if di.damage_types & ~immunities :
		curr_max_hp -= di.damage * max_hp_loss_ration
		curr_hp -= di.damage
		
		if curr_hp <= 0.0 :
			parent.die()
		hurted.emit()
		if can_impulse:
			parent.impulse(di.impulse_vector)
		
		##print(str("someone's health pool is now ", curr_hp))
	

func reset() :
	curr_max_hp = max_hp
	curr_hp = max_hp
	
	if hurtboxes == null:			# bind hurtboxes
		queue_free()
	else : 
		for h in hurtboxes:
			h.health_pool = self
		hurtboxes = []				# decouple
	parent = $".."


func heal(healing : float):
	curr_hp = minf(curr_max_hp,curr_hp+healing)


func _on_player_death():
	curr_max_hp = max_hp
	curr_hp = max_hp

func increase_max(max_gain):
	var burn_ratio = (max_hp - curr_max_hp) / max_hp
	max_hp += max_gain
	curr_max_hp += max_gain
