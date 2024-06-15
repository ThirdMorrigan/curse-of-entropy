extends Control


func _ready():
	$VBoxContainer/PLAY_BUTT.pressed.connect(_on_play_pressed)
	$VBoxContainer/QUIT_BUTT.pressed.connect(_on_quit_pressed)


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/world_map.tscn")

func _on_quit_pressed():
	get_tree().quit()
