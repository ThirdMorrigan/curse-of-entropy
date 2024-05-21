extends Node


enum item_types {KEY, CONSUMABLE, TOOL}
enum map_zone {GARDEN,GRAVEYARD,CASTLE,CRYPT,DUNGEON,CAVE,SEWER}


var itemLookupTable = {
	1 : {
		"name" : "Small Key",
		"type" : item_types.KEY
	}
}
