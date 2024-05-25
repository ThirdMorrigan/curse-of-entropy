extends Control
var is_open = false
var last_tab = GameDataSingleton.item_types.KEY
@export var catagory_buttons: ButtonGroup
@onready var inventory = load("res://_PROTO_/inventroy.tres")
@onready var item_slot_container = get_node("VScrollBar/ItemSlotContainer")
const item_slot_path = "res://_PROTO_/inventory_ui_item_slot.tscn"

signal inventoryState

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	#test_populate()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if Input.is_action_just_pressed("toggle_inventory"):
		if is_open:close()
		else:open()
			
	
func open():
	visible = true
	is_open = true
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	populate_inventory(last_tab)
	inventoryState.emit(true)

func close():
	visible = false
	is_open = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	inventoryState.emit(false)
	
#Each item type button calls this with the corresponding id for the item type enum
func populate_inventory(type_id: int):
	last_tab = type_id
	#Clear existing itemslots
	for item_slot in item_slot_container.get_children():
		item_slot_container.remove_child(item_slot)
		item_slot.queue_free()
		
	var bag = inventory.bags[type_id]
	var items = bag.keys()
	
	for item in items:
		var new_item_slot = preload(item_slot_path).instantiate()
		new_item_slot.text = GameDataSingleton.itemLookupTable[item].name
		item_slot_container.add_child(new_item_slot)

	
	
func test_populate():
	inventory.add(1)
	inventory.add(2)
	inventory.add(3)
	
