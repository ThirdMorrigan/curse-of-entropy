@tool
extends MeshInstance3D

@export var hideInEditor : bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		visible = !hideInEditor


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
