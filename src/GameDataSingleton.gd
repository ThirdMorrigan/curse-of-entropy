@tool
extends Node


enum item_types {KEY, CONSUMABLE, TOOL,NOTE}
enum consumeable_type {HEALTH,MANA,STAMINA}
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
		"visuals" : "res://scenes/visuals/potion_visuals.tscn",
		"resource" : consumeable_type.HEALTH,
		"strength" : 25
	},
	7 : {
		"name" : "Highjump Boots",
		"type" : item_types.TOOL,
		"description" : "FOR YOUR OWN SAFETY DO NOT WEAR THEM ON YOUR HANDS AND PUNCH A WALL",
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
		"name" : "Dungeon airlock inner key", # IN CAFETERIA GRAPPLE AREA
		"type" : item_types.KEY,
		"description" : "This key appears to open one of the doors in the
		airlock that separates the Dungeon and Castle",
		"visuals" : key_visuals
	},
	12 : {
		"name" : "Dungeon kitchen key",
		"type" : item_types.KEY,
		"description" : "It would be indistinguishable from all the other dungeon keys,
		were it not for the \"KITCHEN\" etched into the side.",
		"visuals" : key_visuals
	},
	13 : {
		"name" : "Castle front door key",
		"type" : item_types.KEY,
		"description" : "Good find.",
		"visuals" : key_visuals
	},
	14 : {
		"name" : "Clock Tower key",
		"type" : item_types.KEY,
		"description" : "A key for the nearby clocktower and its side path",
		"visuals" : key_visuals
	},
	15 : {
		"name" : "Block A Cell 5 key", # IN SIDE ROOM
		"type" : item_types.KEY,
		"description" : "The key to a cell in the Dungeon. Opens cell A5.",
		"visuals" : key_visuals
	},
	16 : {
		"name" : "Block A Cell 2 key",
		"type" : item_types.KEY,
		"description" : "The key to a cell in the Dungeon. Opens cell A2.",
		"visuals" : key_visuals
	},
	17 : {
		"name" : "Block A Cell 8 key",
		"type" : item_types.KEY,
		"description" : "The key to a cell in the Dungeon. Opens cell A8.",
		"visuals" : key_visuals
	},
	18 : {
		"name" : "Dungeon Internal Gate Key", # IN CELL 5
		"type" : item_types.KEY,
		"description" : "This key opens a gate somewhere in the dungeon.",
		"visuals" : key_visuals
	},
	19 : {
		"name" : "Dungeon Storage Room Key", # ON THRALL IN PILLAR 0
		"type" : item_types.KEY,
		"description" : "This key opens a storage room in the dungeon.",
		"visuals" : key_visuals
	},
	20 : {
		"name" : "Chapel",
		"type" : item_types.KEY,
		"description" : "A key to the castle chapel.",
		"visuals" : key_visuals
	},
	21 : {
		"name" : "Large health potion",
		"type" : item_types.CONSUMABLE,
		"visuals" : "res://scenes/visuals/potion_visuals.tscn",
		"resource" : consumeable_type.HEALTH,
		"strength" : 50
	},
	22 : {
		"name" : "Staff of fireball",
		"type" : item_types.TOOL,
		"description" : "this staff is preety cool"
	},
	23 : {
		"name" : "Staff of arcane burst",
		"type" : item_types.TOOL,
		"description" : "this staff is preety cool"
		},
	24 : {
		"name" : "Dungeon Trapdoor key", # IN CELL 8
		"type" : item_types.KEY,
		"description" : "This key opens a trapdoor somewhere in the dungeon.",
		"visuals" : key_visuals
	},
	25 : {
		"name" : "Jailer's Quarters key", # ON JAILER
		"type" : item_types.KEY,
		"description" : "the key to the Jailer's quarters.",
		"visuals" : key_visuals
	}
}

	
