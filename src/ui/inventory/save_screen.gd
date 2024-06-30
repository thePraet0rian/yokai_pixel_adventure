extends Node2D


signal save_screen_close


const INVENTORY_BUTTONS_LENGHT: int = 2


@onready var Buttons: Array[Sprite2D] = [
	$Sprite2D,
	$Sprite2D2,
]


var input: int = 0


# Public Methods # --------------------------------------------------------------------------------


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("move_left"):
		if input > 0:
			input -= 1
	
	if event.is_action_pressed("move_right"):
		if input < 1:
			input += 1
	
	for i in range(INVENTORY_BUTTONS_LENGHT):
		
		if i == input:
			Buttons[i].frame = 1
		else:
			Buttons[i].frame = 0
	
	if event.is_action_pressed("space"):
		_match_input()


func _match_input() -> void:
	
	match input:
		0:
			global.on_game_saved.emit()
			await get_tree().create_timer(.5).timeout
			_end()
		
		1:
			_end()


func _end() -> void:
	
	await get_tree().physics_frame
	save_screen_close.emit(0)
	visible = false


# -------------------------------------------------------------------------------------------------
