extends Control

@onready var title = $title
@onready var descrition = $descrition
@onready var age_label = $age
@onready var strength_label = $strength
@onready var intelligence_label = $intelligence
@onready var quantity = $quantity

var inventory = preload("res://_PROTO_/inventroy.tres")

func connect_button(item : ItemButton):
	item.display_item.connect(_display_item)

func _display_item(item):
	print($"..".character_details.strength)
	if item:
		title.text = GameDataSingleton.itemLookupTable[item].name
		quantity.text = "Held: " + str(inventory.get_quantity(item))
		if "description" in GameDataSingleton.itemLookupTable[item]:
			descrition.text = GameDataSingleton.itemLookupTable[item].description
		else:
			descrition.text = "item of id " + GameDataSingleton.itemLookupTable[item].name + " has no descrition"
		age_label.text = str($"..".character_details.age)
		strength_label.text = str($"..".character_details.strength)
		intelligence_label.text = str($"..".character_details.intelligence)
	else:
		title.text = ""
		descrition.text = ""
		quantity.text = ""
		age_label.text = str($"..".character_details.age)
		strength_label.text = str($"..".character_details.strength)
		intelligence_label.text = str($"..".character_details.intelligence)
	
