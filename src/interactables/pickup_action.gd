extends InteractableAction
class_name PickupAction
var inventory = load("res://_PROTO_/inventroy.tres")



func _on_interact():
	inventory.add(interactable.id, interactable.quantity)
	interactable.queue_free()


