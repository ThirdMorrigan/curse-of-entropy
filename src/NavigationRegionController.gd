extends NavigationRegion3D
class_name NavigationRegionController
@onready var func_godot_map = $FuncGodotMap

func _ready():
	for entity in func_godot_map.get_children():
		if entity is Door or entity is BreakableWall:
			print("got door?")
			entity.opened.connect(_reload_nav_mesh)
	bake_finished.connect(_on_bake_finished)

func _reload_nav_mesh():
	bake_navigation_mesh(true)



func _on_bake_finished():
	print("new nav mesh generated")
