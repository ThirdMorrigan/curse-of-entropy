extends Resource

var bags = {}
var equipment = {}

signal equipmentChanged

#these need definitions for when its empty
#a manuel check for 0 could work or maybe any negetive value
func _init():
	for type in GameDataSingleton.item_types.values():
		bags[type] = {}
	for slot in GameDataSingleton.equipment_slots.values():
		equipment[slot] = 0


func bagHasByID(id,type):
	return bags[type].has(id)

func add(id, amount):
	var item = GameDataSingleton.itemLookupTable[id]
	if id in bags[item["type"]]:
		bags[item["type"]][id] += amount
	else:
		bags[item["type"]][id] = amount
	print(bags)

func updateEquipment(id):
	var item = GameDataSingleton.itemLookupTable[id]
	equipment[item["slot"]] = id
	equipmentChanged.emit(item["slot"],id)

func playerHas(id):
	var item = GameDataSingleton.itemLookupTable[id]
	if id in bags[item["type"]]:
		return bags[item["type"]][id] > 0
	else:
		return false

func consumeItem(id):
	var item = GameDataSingleton.itemLookupTable[id]
	bags[item["type"]][id] -= 1
