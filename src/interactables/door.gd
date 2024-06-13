@tool
extends Interactable
class_name Door

enum states {LOCKED,CLOSED,OPEN, ONEWAY}
@export var state : states :
	get:
		return state
	set(s):
		state = s
		if link != null:
			if s == states.OPEN:
				link.enabled = true
			else:
				link.enabled = false
@export var keyID : int = 0

@export var func_godot_properties : Dictionary

var link : NavigationLink3D

signal opened

func _ready():
	_interactable_ready()
	set_interaction_text()
	link = $link
	opened.connect(_on_opened)
	
func _func_godot_apply_properties(props: Dictionary) -> void:
	state = props["state"] as states
	keyID = props["key"] as int

func _on_opened():
	#print("opened")
	if link != null :
		link.enabled = true

func _physics_process(_delta):
	if !Engine.is_editor_hint():
		set_interaction_text()

func set_interaction_text():
	var text = ""
	match state:
		states.LOCKED:
			text = "locked"
		states.CLOSED:
			text = "open"
		states.ONEWAY:
			if wrong_side_test():
				text = "open"
			else:
				text = "can't be opened from this side"
	interactionText = text

func wrong_side_test() -> bool: 
	return $Area3D.get_overlapping_areas().size()
