extends Node


enum item_types {KEY, CONSUMABLE, TOOL}
enum map_zone {GARDEN,GRAVEYARD,CASTLE,CRYPT,DUNGEON,CAVE,SEWER}
enum equipment_slots {TOOL, HEAD, BODY, FEET, HANDS}

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
		"slot" : equipment_slots.TOOL
	},
	4 : {#key for the cell in the tutorial
		"name" : "Cell key",
		"type" : item_types.KEY
	},
	5 : {#key for the exit of the tutorial
		"name" : "Cave emergency exit key",
		"type" : item_types.KEY
	},
	
}
