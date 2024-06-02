extends InteractableAction


func _on_interact():
	GameDataSingleton.respawn_point = interactable.position
