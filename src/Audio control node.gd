extends Node3D
@onready var music : AudioStreamPlayer = $music
@onready var player_sfx_footsteps : AudioStreamPlayer = $player_sfx_footsteps

@onready var player = $"../../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_moving()


func _on_new_room_entered(roomData : Dictionary):
	#print(roomData)
	match roomData["zone"]:
		GameDataSingleton.map_zone.GARDEN:
			music.play()
		# GameDataSingleton.map_zone.GARDEN:


func player_moving():
	if player.velocity.length_squared()>0.001 && player.is_on_floor():
		if !player_sfx_footsteps.playing:
			player_sfx_footsteps.play()
	else:
		player_sfx_footsteps.stop()
