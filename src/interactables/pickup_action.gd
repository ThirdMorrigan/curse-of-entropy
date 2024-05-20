extends InteractableAction
class_name PickupAction
var inventory = load("res://_PROTO_/inventroy.tres")
var itemData

@export var id : int = 1

func _on_interact():
	inventory.add(id)
	print(inventory.bags)
	interactable.queue_free()


