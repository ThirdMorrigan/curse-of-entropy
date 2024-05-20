extends InteractableAction

const INVENTORY_FOR_TYPES_ONLY = preload("res://src/inventory.gd")
var inventory = load("res://_PROTO_/inventroy.tres")
@export var type : INVENTORY_FOR_TYPES_ONLY.types

func _on_interact():
	inventory.bags[type].append(interactable.toDict())
	interactable.queue_free()
	print(inventory.bags[type])

