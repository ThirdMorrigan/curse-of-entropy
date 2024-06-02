extends Node3D
@onready var music : AudioStreamPlayer = $music


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_new_room_entered(roomData : Dictionary):
	#print(roomData)
	match roomData["zone"]:
		GameDataSingleton.map_zone.GARDEN:
			music.play()
		# GameDataSingleton.map_zone.GARDEN:
