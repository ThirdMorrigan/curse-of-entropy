extends DoorAction

class_name BrushDoorAction

func open():
	#print("open")
	interactable.start_opening()
	pass

func failedOpen():
	#animation_player.play("failed_open")
	pass
