extends Node2D


enum STATE {ONE = 1, TWO = 2}

var index: int = 1
var current_state: STATE = STATE.ONE

@onready var Buttons: Array[Sprite2D] = [
	$back_button,
	$normal_selector,
	$back_button3,
	$back_button4
]


func _input(event: InputEvent) -> void:
	
	match current_state:
		0:
			_input_one(event)
		1:
			_input_two(event)


func _input_one(event: InputEvent) -> void: 
	
	if event.is_action_pressed("move_left"):
		if index < 0:
			index = 3
		else:
			index -= 1
	elif event.is_action_pressed("move_right"):
		if index > 2:
			index = 0
		else:
			index += 1
	
	for i in range(4):
		Buttons[i].frame = 0
	
	Buttons[index].frame = 1


func _input_two(event: InputEvent) -> void:
	
	pass
