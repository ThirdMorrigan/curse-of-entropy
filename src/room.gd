extends Area3D
class_name Room

@export var zone : GameDataSingleton.map_zone
@export var indoors : bool = true
@onready var collision_shape_3d = $CollisionShape3D
@onready var func_godot_map = $NavigationRegion3D/FuncGodotMap


var bounding_box : AABB

# Called when the node enters the scene tree for the first time.
func _ready():
	if func_godot_map == null:
		print("func_godot map is required")
	else:
		bounding_box = func_godot_map.get_child(0).get_child(0).get_aabb()
		#here i add a the height of 1m to the height to make sure its tall enough if there are no high walls for instance
		#todo make it reach a minimum of the players height
		collision_shape_3d.shape.size = bounding_box.size + Vector3(0,1,0)
		collision_shape_3d.position = bounding_box.position + bounding_box.size * 0.5

func toDict():
	return {
		"indoors" : indoors,
		"zone" : zone
	}


func _on_area_entered(area):
		area.changeRoom(toDict())
