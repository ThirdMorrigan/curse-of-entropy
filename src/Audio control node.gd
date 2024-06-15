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
const LANDING_BIG = preload("res://audio/landing big.wav")
const LANDING_SMALL = preload("res://audio/landing small.wav")
const PLAYER_HIT_1 = preload("res://audio/player hit 1.wav")
const PLAYER_HIT_2 = preload("res://audio/player hit 2.wav")
const PLAYER_HIT_3 = preload("res://audio/player hit 3.wav")
const PLAYER_DEATH_AAAH = preload("res://audio/player death AAAH.wav")
const POTION_DRINK = preload("res://audio/potion drink.wav")
const CRYPT___AMBIENT = preload("res://audio/Crypt - Ambient.wav")
const DUNGEON___AMBIENT = preload("res://audio/Dungeon - Ambient.wav")
const MAIN_MENU = preload("res://audio/Main Menu.wav")

var hit_sounds = [PLAYER_HIT_1,PLAYER_HIT_2,PLAYER_HIT_3]
@onready var player_sfx_footsteps : AudioStreamPlayer = $player_sfx_footsteps
@onready var health_pool = $"../../../HealthPool"
@onready var player = $"../../.."
@onready var fall_damage_player = $fall_damage
@onready var damage = $damage

# Called when the node enters the scene tree for the first time.
func _ready():
	health_pool.hurted.connect(_player_hit)
	current_music.volume_db = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	player_moving()


func _on_new_room_entered(roomData : Dictionary):
	##print(roomData)
	# SFX processing for inside vs outside reverb
	if roomData.indoors == true :
		##print("inside")
		AudioServer.set_bus_effect_enabled(2,1,true)
	if roomData.indoors == false :
		##print("OUTSIDE")
		AudioServer.set_bus_effect_enabled(2,0,false)
	
	# room checking to set current zone music
	if roomData.zone != player_current_zone :
		match roomData["zone"]:
			GameDataSingleton.map_zone.GARDEN:
				change_zone_music(GARDEN___AMBIENT_1)
			GameDataSingleton.map_zone.CAVE:
				change_zone_music(CAVE___AMBIENT)
			GameDataSingleton.map_zone.CRYPT:
				change_zone_music(CRYPT___AMBIENT)
			GameDataSingleton.map_zone.GRAVEYARD:
				change_zone_music(CRYPT___AMBIENT)
			GameDataSingleton.map_zone.DUNGEON:
				change_zone_music(DUNGEON___AMBIENT)
			GameDataSingleton.map_zone.SEWER:
				change_zone_music(DUNGEON___AMBIENT)
			GameDataSingleton.map_zone.CASTLE:
				change_zone_music(MAIN_MENU)
		player_current_zone = roomData.zone
	
func change_zone_music(next_track):
	##print(next_track)
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


func _on_crossfade_finished(_anim_name):
	flipped = !flipped

func fall_damage(big_fall):
	if big_fall:
		fall_damage_player.stream = LANDING_BIG
	else:
		fall_damage_player.stream = LANDING_SMALL
	fall_damage_player.play()

func _player_hit():
	damage.stream = hit_sounds.pick_random()
	damage.play()

func player_die():
	damage.stream = PLAYER_DEATH_AAAH
	damage.play()

func player_drink_potion():
	damage.stream = POTION_DRINK
	damage.play()
