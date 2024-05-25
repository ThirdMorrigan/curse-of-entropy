extends Area3D
class_name Interactable

@export var objectName : String = "default name"
@export var id : int = 0
@export var quantity : int = 1
signal interact

func _ready():
	print(rotation_degrees)
	collision_layer = 4


func interacted():
	interact.emit()

#func getBasicData():
	#return {
		#"name" : objectName,
		#"id" : id
		#
	#}
#
##should be overwritten for more complex item.
##getBasicData will collect all nessary data for all items that can be stored
#func toDict():
	#return getBasicData()
