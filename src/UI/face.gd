extends Control
@onready var hair = $hair
@onready var face = $face

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_face(face_frame,hair_frame,skin_colour,hair_colour):
	face.frame = face_frame
	hair.frame = hair_frame
	face.modulate = skin_colour
	hair.modulate = hair_colour
