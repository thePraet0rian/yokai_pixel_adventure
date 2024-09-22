extends Node2D


func _input(event: InputEvent) -> void:	
	if event.is_action_pressed("shift"):
		_end()


func _end() -> void:
	visible = false
	GlobalBattle.disable_ui.emit(0)
	process_mode = Node.PROCESS_MODE_DISABLED
