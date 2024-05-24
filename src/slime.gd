extends Creature

@export var _player : Player

func _ready():
	super()#
	$CreatureAI.player = _player
