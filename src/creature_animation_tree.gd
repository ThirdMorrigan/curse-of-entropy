extends AnimationTree

class_name CreatureAnimationTree

var creature : Creature
var current_state : Creature.State

signal attack_finished

@export var track_target : bool = true :
	get:
		return track_target
	set(t):
		track_target = t
		if creature != null :
			creature.track_target = t
@export var fire_attack : bool = false :
	set(f):
		#print("setting fire")
		if f :
			fire_current_attack()


func _ready():
	creature = $".."
	track_target = true
	creature.state_changed.connect(_on_creature_state_changed)
	animation_finished.connect(_on_animation_finished)
	fire_attack = false
	
	

func _on_creature_state_changed():
	current_state = creature.current_state


func _on_animation_finished(anim_name : String):
	anim_name = anim_name.to_upper()
	if anim_name.begins_with("ATTACK"):
		#print("setting state in anim controller anim fginished")
		creature.current_state = creature.State.IDLE
		attack_finished.emit()

func fire_current_attack():
	#print("trying to fire")
	if creature != null:
		creature.attacks[creature.current_attack()].fire()
