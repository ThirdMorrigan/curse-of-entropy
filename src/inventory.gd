extends Resource



var bags = {}

func _init():
	for type in GameDataSingleton.item_types.values():
		bags[type] = {}
	print(bags)


func searchBagByID(bag,id):
	pass
