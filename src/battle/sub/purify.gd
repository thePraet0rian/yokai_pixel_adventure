extends Node2D


@onready var Parent: YokaiHelper = get_parent().get_parent().get_parent().BattleYokaiHelper


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("shift"):
		Parent.current_game_state = Parent.GAME_STATES.SELECTING
		visible = false
		process_mode = Node.PROCESS_MODE_DISABLED
