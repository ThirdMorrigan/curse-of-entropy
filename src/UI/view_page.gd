extends Control

@onready var title = $title
@onready var descrition = $descrition
@onready var age = $age

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func connect_button(item : ItemButton):
	item.display_item.connect(_display_item)

func _display_item(item):
	title.text = GameDataSingleton.itemLookupTable[item].name
	if "description" in GameDataSingleton.itemLookupTable[item]:
		descrition.text = GameDataSingleton.itemLookupTable[item].description
	else:
		descrition.text = "item of id " + str(item) + " has no descrition"
	age.text = str($"..".character_details.age)
	
