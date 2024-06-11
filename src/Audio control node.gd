extends Node3D
var player_current_zone : GameDataSingleton.map_zone
@onready var music_garden_ambient : AudioStreamPlayer = $music_garden_ambient
@onready var music_cave_ambient : AudioStreamPlayer = $music_cave_ambient

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
	if roomData.indoors == true :
		print("inside")
		AudioServer.set_bus_effect_enabled(2,0,true)
	if roomData.indoors == false :
		print("OUTSIDE")
		AudioServer.set_bus_effect_enabled(2,0,false)
	
	if roomData.zone == player_current_zone :
		pass
	match roomData["zone"]:
		GameDataSingleton.map_zone.GARDEN:
			music_garden_ambient.play()
		GameDataSingleton.map_zone.CAVE:
			music_cave_ambient.play()
	player_current_zone = roomData.zone
	
func change_zone_music():
	
	pass


func player_moving():
	if player.velocity.length_squared()>0.001 && player.is_on_floor():
		if !player_sfx_footsteps.playing:
			player_sfx_footsteps.play()
	else:
		player_sfx_footsteps.stop()
