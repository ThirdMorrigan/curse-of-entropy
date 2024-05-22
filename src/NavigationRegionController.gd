extends NavigationRegion3D

@onready var func_godot_map = $FuncGodotMap

func _ready():
	for entity in func_godot_map.get_children():
		if entity is Door:
			print("got door?")
			entity.opened.connect(_reload_nav_mesh)

func _reload_nav_mesh():
	bake_navigation_mesh(true)



func _on_bake_finished():
	print("new nav mesh generated")
