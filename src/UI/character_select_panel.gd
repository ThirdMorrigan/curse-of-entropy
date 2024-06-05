extends Control

@onready var face = $face
@onready var name_label = $VBoxContainer/name
@onready var age_label = $VBoxContainer/age
@onready var strength_label = $VBoxContainer/strength
@onready var intelligence_label = $VBoxContainer/intelligence

var character
# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.pressed.connect(_on_character_select)
	#new_character()
	pass # Replace with function body.


func new_character():
	character = PlayerCharacter.new()
	add_child(character)
	face.update_face(character.face,character.hair,character.skin_colour,character.hair_colour)
	name_label.text = character.character_name
	age_label.text = str(character.age)
	strength_label.text = "Strength: " + str(character.strength)
	intelligence_label.text = "Intelligence: " + str(character.intelligence)

func _on_character_select():
	get_tree().call_group("player","new_character",character)
	$"../..".reload()
