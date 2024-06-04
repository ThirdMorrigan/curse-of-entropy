extends Control

@onready var face = $face

var character
# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.pressed.connect(_on_character_select)
	new_character()
	pass # Replace with function body.


func new_character():
	character = PlayerCharacter.new()
	add_child(character)
	face.update_face(character.face,character.hair,character.skin_colour,character.hair_colour)

func _on_character_select():
	get_tree().call_group("player","new_character",character)
	$"../..".reload()
