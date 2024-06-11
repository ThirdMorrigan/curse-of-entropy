extends AnimationTree

@export var attack_horizontal : bool
@export var attack_vertical : bool
@export var attack_cast : bool
@export var wake : bool

@export var fire_attack : bool 

@onready var swing_vertical = $"../swing_vertical"
@onready var swing_horizontal = $"../swing_horizontal"

var player : Player

var horizontal_height
var sweep_offset
var sweep_scale

signal fire

# Called when the node enters the scene tree for the first time.
func _ready():
	var to_low = $"../low_swipe".global_position - $"../chest".global_position
	var to_high = $"../high_swipe".global_position - $"../chest".global_position
	var low_swipe = to_low.normalized.y
	var high_swipe = to_high.normalized.y
	sweep_offset = -low_swipe
	sweep_scale = 1/(high_swipe + low_swipe)
	fire_attack = false


func saturate(x, offset, scale) -> float:
	return (x + offset) * scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if player != null:
		var to_player = player.global_position - $"../chest".global_position
		to_player = to_player.normalized()
		horizontal_height = saturate 
	if fire_attack :
		attack_horizontal = false
		attack_vertical = false
		attack_cast = false
		fire_attack = false
		fire.emit()
