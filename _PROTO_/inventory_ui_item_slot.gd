extends Panel
@export var text: String

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("ItemNameLabel").add_text(text)
