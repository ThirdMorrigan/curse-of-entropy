extends Resource

var bags = {}
var equipment = {}

signal equipmentChanged
signal jump_boots
signal fireball
signal pickaxe
signal arcane
signal grapple
signal health_crystal
signal mana_crystal
signal str_crystal
signal int_crystal

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
	check_tool(id)

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

func get_quantity(id):
	var item = GameDataSingleton.itemLookupTable[id]
	if bagHasByID(id,item["type"]):
		return bags[item["type"]][id]
	else:
		return 0

func setup_tools():
	for item in bags[GameDataSingleton.item_types.TOOL].keys():
		check_tool(item)


func check_tool(id):
	match id:
		7:
			jump_boots.emit()
			#print("testing 124")
		3:
			pickaxe.emit()
		22:
			fireball.emit()
		23:
			arcane.emit()
		27:
			grapple.emit()
		33:
			health_crystal.emit()
		34:
			mana_crystal.emit()
		35:
			str_crystal.emit()
			print("emit")
		36:
			int_crystal.emit()
		
