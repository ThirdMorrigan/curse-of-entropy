@tool
extends Interactable

@export var func_godot_properties : Dictionary
@export var visuals : Resource 

func _func_godot_apply_properties(props: Dictionary) -> void:
	id = props["id"]
	quantity = props["quantity"]
	visuals = load(GameDataSingleton.itemLookupTable[id]["visuals"])
	var visuals_instance = visuals.instantiate()
	#print(visuals)
	add_child(visuals_instance)

func _ready():
	_interactable_ready()
	set_interactable_text()
	if visuals != null:
		var visuals_instance = visuals.instantiate()
		add_child(visuals_instance)

func set_interactable_text():
	interactionText ="pick up " + GameDataSingleton.itemLookupTable[id]["name"]
