@tool
extends Node


enum item_types {KEY, CONSUMABLE, TOOL,NOTE}
enum map_zone {GARDEN,GRAVEYARD,CASTLE,CRYPT,DUNGEON,CAVE,SEWER}
enum equipment_slots {TOOL, HEAD, BODY, FEET, HANDS}

@export var respawn_point : Vector3 = Vector3.ZERO

var key_visuals = "res://scenes/visuals/key_visuals.tscn"

var itemLookupTable = {
	0 : {
		"name" : "Error ID has not been set to a real item",
		"type" : item_types.KEY
	},
	1 : {
		"name" : "Small Key",
		"type" : item_types.KEY
	},
	2 : {
		"name" : "Small Key 2",
		"type" : item_types.KEY
	},
	3 : {
		"name" : "Pickaxe",
		"type" : item_types.TOOL,
		"slot" : equipment_slots.TOOL,
		"visuals" : "res://assets/models/pickaxe.glb"
	},
	4 : {#key for the cell in the tutorial
		"name" : "South west courtyard key",
		"type" : item_types.KEY,
		"description" : "A key found in the fountain of the courtyard,
		the base of the key depicts a compass pointing to the south west",
		"visuals" : key_visuals
	},
	5 : {#key for the exit of the tutorial
		"name" : "Cave emergency exit key",
		"type" : item_types.KEY,
		"visuals" : key_visuals
	},
	6 : {
		"name" : "Small health potion",
		"type" : item_types.CONSUMABLE,
		"visuals" : "res://scenes/visuals/potion_visuals.tscn"
	},
	7 : {
		"name" : "Jump boots",
		"type" : item_types.TOOL,
		"description" : "She jump on my boot until i shit my pants",
		"visuals" : "res://scenes/visuals/boots_visuals.tscn"
	},
	8 : {
		"name" : "Climbers gloves",
		"type" : item_types.TOOL,
		"visuals" : "res://scenes/visuals/gloves_visuals.tscn"
	},
	9 : {
		"name" : "Garden gate key",
		"type" : item_types.KEY,
		"visuals" : key_visuals
	},
	10 : {
		"name" : "Block A Cell 4 key",
		"type" : item_types.KEY,
		"description" : "The key to a cell in the Dungeon. Opens cell A4.",
		"visuals" : key_visuals
	},
	11 : {
		"name" : "Dungeon airlock inner key",
		"type" : item_types.KEY,
		"description" : "This key appears to open one of the doors in the
		airlock that separates the Dungeon and Castle",
		"visuals" : key_visuals
	}
	
}

	
