extends InteractableAction
class_name PickupAction
var inventory = load("res://_PROTO_/inventroy.tres")
@onready var audio_stream_player_3d = $"../AudioStreamPlayer3D"



func _on_interact():
	if audio_stream_player_3d != null :
		audio_stream_player_3d.play()
	inventory.add(interactable.id, interactable.quantity)
	interactable.queue_free()


