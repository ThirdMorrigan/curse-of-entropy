extends InteractableAction
class_name DoorAction
@onready var animation_player = $"../Container/AnimationPlayer"
@onready var area_3d = $"../Area3D"


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
		interactable.states.ONEWAY:
			if area_3d.get_overlapping_areas().size():
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
