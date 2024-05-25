extends Resource



var bags = {}
#these need definitions for when its empty
#a manuel check for 0 could work or maybe any negetive value
var equipment = {
	"tool" : 3,
	"head" : 0,
	"body" : 0,
	"feet" : 0,
	"hands" : 0
}
func _init():
	for type in GameDataSingleton.item_types.values():
		bags[type] = {}
	print(bags)


func bagHasByID(id,type):
	return bags[type].has(id)

func add(id):
	var item = GameDataSingleton.itemLookupTable[id]
	bags[item["type"]][id] = 1
	
