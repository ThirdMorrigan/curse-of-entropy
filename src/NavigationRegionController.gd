extends NavigationRegion3D
class_name NavigationRegionController
var func_godot_map
var baking : bool = false
var queue : bool = false

func _ready():
	func_godot_map = $"..".find_children("*", "FuncGodotMap")[0]
	for entity in func_godot_map.get_children():
		if entity is Door or entity is BreakableWall or entity is FuncDoor:
			entity.opened.connect(_reload_nav_mesh)
	bake_finished.connect(_on_bake_finished)

func _reload_nav_mesh():
	if baking:
		queue = true
	else:
		bake_navigation_mesh(true)
		baking = true
	



func _on_bake_finished():
	#print("new nav mesh generated")
	baking = false
	#if queue:
		#_reload_nav_mesh()
