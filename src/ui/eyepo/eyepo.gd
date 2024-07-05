# --------------------------------------------------------------------------------------------------
class_name Eyepo extends CanvasLayer


@onready var buttons: Array[Sprite2D] = [
	$heal_button, 
	$switch_button,
	$close_button,
]


var button_index: int = 0


# METHODS # ----------------------------------------------------------------------------------------


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("move_down"):
		if button_index < 3:
			button_index += 1
		
	if event.is_action_pressed("move_up"):
		if button_index > 0: 
			button_index -= 1
	
	if event.is_action_pressed("shift"):
		_close()
	
	for i in range(len(buttons)):
		if i == button_index:
			buttons[i].frame = 1
		else: 
			buttons[i].frame = 0


func _close() -> void:
	pass


# --------------------------------------------------------------------------------------------------
