extends Control


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	if $VBoxContainer/PLAY_BUTT != null:
		$VBoxContainer/PLAY_BUTT.pressed.connect(_on_play_pressed)
	$VBoxContainer/QUIT_BUTT.pressed.connect(_on_quit_pressed)
	if $VBoxContainer/MENU_BUTT != null:
		$VBoxContainer/MENU_BUTT.pressed.connect(_on_main_menu_pressed)


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/world_map.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
