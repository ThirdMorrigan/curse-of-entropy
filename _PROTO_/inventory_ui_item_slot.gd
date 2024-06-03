extends Button
var name_text: String = "missing name"
var quantity_text: String = "0"
@onready var item_name_label = $ItemNameLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	item_name_label.add_text(name_text + "		Held:	" + quantity_text)


func _on_pressed():
	print("button test")
