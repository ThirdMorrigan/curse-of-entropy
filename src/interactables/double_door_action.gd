extends InteractableAction

@onready var animation_player = $"../AnimationPlayer"
enum states {LOCKED,CLOSED,OPEN}
@export var state : states

func _on_interact():
	match state:
		states.LOCKED:
			var keyID = interactable.key.ID
			var inv = load("res://_PROTO_/inventroy.tres")
		states.CLOSED:
			animation_player.play("door_open")
			state = states.OPEN
		states.OPEN:
			print("already open")
