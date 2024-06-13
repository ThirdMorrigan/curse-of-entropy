@tool
extends MeshInstance3D

@export var hideInEditor : bool = true
@export var hideInRunTime : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		visible = !hideInEditor
	else:
		visible = !hideInRunTime
