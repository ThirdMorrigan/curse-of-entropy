extends Area3D
class_name Interactable

static var uniqueIDCounter = 0
@export var objectName : String = "default name"
var ID
signal interact

func _ready():
	collision_layer = 4
	ID = uniqueIDCounter
	uniqueIDCounter += 1


func interacted():
	interact.emit()

func getBasicData():
	return {
		"name" : objectName,
		"id" : ID
		
	}

#should be overwritten for more complex item.
#getBasicData will collect all nessary data for all items that can be stored
func toDict():
	return getBasicData()
