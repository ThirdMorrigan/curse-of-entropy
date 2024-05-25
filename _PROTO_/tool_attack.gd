extends Attack
class_name ToolAttack

@onready var requirement = $"requirement"

@export var tool_id : int = 0

signal toolUsed


func useTool():
	if requirement != null:
		if requirement.check():
			toolUsed.emit()
			fire()
	else:
		toolUsed.emit()
		fire()
