extends Node

class_name HealthPool

@export var max_hp : float = 10

@onready var parent : Creature = $".."

var curr_hp : float

func _ready():
	curr_hp = max_hp
	parent.hurt.connect(_on_hurt)

func _on_hurt(di : DamageInstance):
	curr_hp -= di.damage
	if curr_hp < 0.0 :
		parent#.die()
