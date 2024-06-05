extends InteractableAction

const PULL_FUNCTION = "activate"
@onready var visuals = $"../Sketchfab_Scene"


func _on_interact():
	if interactable.bidirectional:
		pull()
	elif not interactable.pulled:
		pull()
		interactable.interactionText = ""

func pull():
	interactable.pulled = !interactable.pulled
	if interactable.target_group != "":
			get_tree().call_group(interactable.target_group,PULL_FUNCTION)
	visuals.play(interactable.pulled)
