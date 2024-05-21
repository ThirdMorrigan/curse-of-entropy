extends InteractableAction
class_name DoorAction
@onready var animation_player = $"../AnimationPlayer"
enum states {LOCKED,CLOSED,OPEN}
@export var state : states
@export var keyID : int = 1
var inventory = preload("res://_PROTO_/inventroy.tres")

func _on_interact():
	match state:
		states.LOCKED:
			if inventory.bagHasByID(keyID,GameDataSingleton.item_types.KEY):
				open()
			else:
				failedOpen()
		states.CLOSED:
			open()
		states.OPEN:
			print("already open")

func open():
	animation_player.play("door_open")
	state = states.OPEN

func failedOpen():
	animation_player.play("failed_open")
