extends Node2D


signal soulimate()
signal _left
signal _right
signal _up
signal _down

enum States {
	Selecting = 0, 
	Soulimate = 1,
	Attacking = 2, 
}

var current_state: States
var soulimate_selected_yokai: int = 0

@onready var BattleInstance: Battle = get_node("../../../..")
@onready var YokaiHelperInstance: BattleYokaiHelper
@onready var SoulimateRect: Sprite2D = $soulimate_rect

@onready var Arrows: Array[Sprite2D] = [
	$soulimate_rect/ArrowDown,
	$soulimate_rect/ArrowUp,
	$soulimate_rect/ArrowLeft,
	$soulimate_rect/ArrowRight,
]


func _ready() -> void:	
	await BattleInstance.ready
	YokaiHelperInstance = BattleInstance.YokaiHelperInstance
	YokaiHelperInstance.set_soulimate_selected_yokai(soulimate_selected_yokai)
	YokaiHelperInstance.disable_soulimate_ui()

func _input(event: InputEvent) -> void:	
	match current_state:
		0:
			_selecting_input(event)
		1:
			_soulimate_input(event)
		2:
			pass

func _selecting_input(event: InputEvent) -> void:	
	if event.is_action_pressed("move_left"):
		if soulimate_selected_yokai > 0:
			soulimate_selected_yokai -= 1
		else: 
			soulimate_selected_yokai = 2
	if event.is_action_pressed("move_right"):
		if soulimate_selected_yokai < 2:
			soulimate_selected_yokai += 1
		else:
			soulimate_selected_yokai = 0
	
	YokaiHelperInstance.set_soulimate_selected_yokai(soulimate_selected_yokai)
	
	if event.is_action_pressed("space"):
		SoulimateRect.visible = true
		current_state = States.Soulimate
		
		start_soulimate(soulimate_selected_yokai)
	
	if event.is_action_pressed("shift"):
		SoulimateRect.visible = false

func _soulimate_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("move_left"):
		_left.emit()
	elif event.is_action_pressed("move_right"):
		_right.emit()
	elif event.is_action_pressed("move_down"):
		_down.emit()
	elif event.is_action_pressed("move_up"):
		_up.emit()
	
	if event.is_action_pressed("shift"):
		SoulimateRect.visible = false
		current_state = States.Selecting

func _attacking_input(_event: InputEvent) -> void:
	pass

func start_soulimate(yokai: int) -> void:
	Arrows[0].visible = true
	await _down
	Arrows[0].visible = false

	Arrows[1].visible = true
	await _up
	Arrows[1].visible = false
	
	YokaiHelperInstance.start_soulimate(yokai)
