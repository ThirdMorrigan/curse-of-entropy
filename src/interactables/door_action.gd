extends InteractableAction
class_name DoorAction
@onready var animation_player = $"../Container/AnimationPlayer"


var inventory = preload("res://_PROTO_/inventroy.tres")

func _on_interact():
	match interactable.state:
		interactable.states.LOCKED:
			if inventory.bagHasByID(interactable.keyID,GameDataSingleton.item_types.KEY):
				open()
			else:
				failedOpen()
		interactable.states.CLOSED:
			open()
		interactable.states.OPEN:
			print("already open")

func open():
	animation_player.play("open")
	interactable.state = interactable.states.OPEN

func failedOpen():
	#animation_player.play("failed_open")
	pass
