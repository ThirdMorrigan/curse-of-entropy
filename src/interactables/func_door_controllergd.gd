extends Node
class_name FuncDoorController

@export var doors :Array[FuncDoor]
@export var target : int = 1
@export var group : String = "hey you gotta add something here you silly wanker, you dumb fuck. WHORE!"
var count : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(group)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func activate():
	count += 1
	if count >= target:
		for door in doors:
			door.activate()
