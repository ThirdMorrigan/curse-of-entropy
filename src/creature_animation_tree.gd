extends AnimationTree

class_name CreatureAnimationTree

var creature : Creature
var current_state : Creature.State
@export var fire_attack : bool = false :
	set(f):
		if f :
			fire_current_attack()


func _ready():
	creature = $".."
	creature.state_changed.connect(_on_creature_state_changed)
	animation_finished.connect(_on_animation_finished)
	
	

func _on_creature_state_changed():
	current_state = creature.current_state


func _on_animation_finished(anim_name):
	if anim_name.begins_with("ATTACK_"):
		creature.current_state = creature.State.WALK

func fire_current_attack():
	if creature != null:
		creature.attacks[creature.current_attack()].fire()
