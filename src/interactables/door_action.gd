extends InteractableAction
class_name DoorAction
var animation_player


var inventory = preload("res://_PROTO_/inventroy.tres")

func _ready():
	super()
	if has_node("../Container/AnimationPlayer") :
		animation_player = $"../Container/AnimationPlayer"

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
		interactable.states.ONEWAY:
			if $"..".wrong_side_test():
				open()
	interactable.set_interaction_text()

func open():
	animation_player.play("open")
	
	interactable.state = interactable.states.OPEN

func failedOpen():
	#animation_player.play("failed_open")
	pass


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "open":
		interactable.opened.emit()
