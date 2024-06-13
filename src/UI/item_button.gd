extends Button
class_name ItemButton

signal display_item
var item_id : int
# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(_on_button_pressed)


func _on_button_pressed():
	display_item.emit(item_id)
