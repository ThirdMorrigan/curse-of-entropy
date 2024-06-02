extends Button
class_name ItemButton

signal display_item
var item_id : int
# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(_on_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed():
	display_item.emit(item_id)
