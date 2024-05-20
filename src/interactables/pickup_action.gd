extends InteractableAction

var inventory = load("res://_PROTO_/inventroy.tres")
var itemData
@export var type : GameDataSingleton.item_types

func _on_interact():
	itemData = interactable.toDict()
	#double stores the ID but that isnt the worst thing i think.
	inventory.bags[type][itemData["id"]] = itemData
	interactable.queue_free()
	print(inventory.bags[type])

