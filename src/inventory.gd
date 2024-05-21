extends Resource



var bags = {}

func _init():
	for type in GameDataSingleton.item_types.values():
		bags[type] = {}
	print(bags)


func bagHasByID(id,type):
	return bags[type].has(id)

func add(id):
	var item = GameDataSingleton.itemLookupTable[id]
	bags[item["type"]][id] = 1
