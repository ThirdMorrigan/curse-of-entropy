extends Node3D
@onready var current_music : AudioStreamPlayer = $current_music
@onready var next_music : AudioStreamPlayer = $next_music
var player_current_zone
var flipped = false
#@onready var music_garden_ambient : AudioStreamPlayer = $music_garden_ambient
#@onready var music_cave_ambient : AudioStreamPlayer = $music_cave_ambient

@onready var animation_player = $AnimationPlayer
const CAVE___AMBIENT = preload("res://audio/Cave - Ambient.wav")
const GARDEN___AMBIENT_1 = preload("res://audio/Garden - Ambient 1.wav")

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
		#print("inside")
		AudioServer.set_bus_effect_enabled(2,0,true)
	if roomData.indoors == false :
		#print("OUTSIDE")
		AudioServer.set_bus_effect_enabled(2,0,false)
	
	if roomData.zone != player_current_zone :
		match roomData["zone"]:
			GameDataSingleton.map_zone.GARDEN:
				change_zone_music(GARDEN___AMBIENT_1)
			GameDataSingleton.map_zone.CAVE:
				change_zone_music(CAVE___AMBIENT)
		player_current_zone = roomData.zone
	
func change_zone_music(next_track):
	#print(next_track)
	if current_music.stream != null :
		if !flipped:
			next_music.stream = next_track
			animation_player.play("crossfade_audio_in")
		else:
			current_music.stream = next_track
			animation_player.play("crossfade_audio_out")
	else :
		current_music.stream = next_track
		current_music.play()
	
	

func player_moving():
	if player.velocity.length_squared()>0.001 && player.is_on_floor():
		if !player_sfx_footsteps.playing:
			player_sfx_footsteps.play()
	else:
		player_sfx_footsteps.stop()


func _on_crossfade_finished(anim_name):
	flipped = !flipped
