extends InteractableAction

const PULL_FUNCTION = "activate"
@onready var visuals = $"../Sketchfab_Scene"


func _on_interact():
	if not interactable.pulled:
		if interactable.target_group != "":
			get_tree().call_group(interactable.target_group,PULL_FUNCTION)
		interactable.interactionText = ""
		visuals.play()
