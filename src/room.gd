@tool
extends Area3D
class_name Room

@export var zone : GameDataSingleton.map_zone
@export var indoors : bool = true
@onready var collision_shape_3d = $CollisionShape3D
@onready var func_godot_map : FuncGodotMap = $FuncGodotMap
@onready var level_mesh = $FuncGodotMap/entity_0_worldspawn/entity_0_mesh_instance
var bounding_box : AABB

# Called when the node enters the scene tree for the first time.
func _ready():
	func_godot_map.build_complete.connect(generate_bounding_box)

func toDict():
	return {
		"indoors" : indoors,
		"zone" : zone
	}

func generate_bounding_box():
	func_godot_map = $FuncGodotMap
	level_mesh = $FuncGodotMap/entity_0_worldspawn/entity_0_mesh_instance
	if func_godot_map == null or level_mesh == null:
		print("func_godot map/level mesh is required")
	else:
		bounding_box = level_mesh.get_aabb()
		collision_shape_3d.shape.size = bounding_box.size
		collision_shape_3d.shape.size.y = max(collision_shape_3d.shape.size.y,1.8)
		collision_shape_3d.position = bounding_box.position + bounding_box.size * 0.5


func _on_area_entered(area):
		area.changeRoom(toDict())


func _on_func_godot_map_build_complete():
	generate_bounding_box()
