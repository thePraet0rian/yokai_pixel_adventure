extends Node2D


@onready var Parent: Battle = get_parent().get_parent().get_parent()


func _ready() -> void:
	
	pass


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("shift"):
		Parent.current_game_state = Parent.GAME_STATES.SELECTING
		visible = false
		process_mode = Node.PROCESS_MODE_DISABLED
