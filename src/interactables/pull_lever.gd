extends InteractableAction

const PULL_FUNCTION = "activate"
@onready var visuals = $"../lever"
@onready var audio_stream_player_3d = $"../AudioStreamPlayer3D"


func _on_interact():
	if interactable.bidirectional:
		pull()
	elif not interactable.pulled:
		pull()
		interactable.interactionText = ""

func pull():
	audio_stream_player_3d.play()
	if interactable.target_group != "":
		#print(interactable.target_group)
		get_tree().call_group(interactable.target_group,PULL_FUNCTION)
	visuals.play(interactable.pulled)
	interactable.pulled = !interactable.pulled
