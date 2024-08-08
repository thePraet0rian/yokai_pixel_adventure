class_name Eyepo extends CanvasLayer



@onready var buttons: Array[Sprite2D] = [
	$heal_button, 
	$switch_button,
	$back_button,
]



var button_index: int = 0



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_down"):
		if button_index < 2:
			button_index += 1
		
	if event.is_action_pressed("move_up"):
		if button_index > 0: 
			button_index -= 1
	
	if event.is_action_pressed("shift"):
		_close()
	
	if event.is_action_pressed("space"):
		_check()
	
	for i in range(len(buttons)):
		if i == button_index:
			buttons[i].frame = 1
		else: 
			buttons[i].frame = 0



func _close() -> void:
	await get_tree().process_frame
	get_tree().paused = false
	queue_free()



func _check() -> void:
	match button_index:
		0:
			_heal()
		1:
			print("switch")
		2:
			_close()



func _heal() -> void:
	for i in range(6):
		global.player_yokai[i].yokai_hp = global.player_yokai[i].yokai_max_hp


