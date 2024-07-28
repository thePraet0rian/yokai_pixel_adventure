class_name UiHelper extends Node


signal win_animation_finished
signal ui_hidden
signal ui_shown

enum SUB_GAME_STATES {
	PURIFY = 0, 
	SOULIMATE = 1, 
	TARGET = 2, 
	ITEM = 3, 
	NONE = 4,
}

var current_state: SUB_GAME_STATES = SUB_GAME_STATES.NONE

@onready var MainMenueButtons: Array[Sprite2D] = [
	$main_menue/buttons/purify,
	$main_menue/buttons/soulimate,
	$main_menue/buttons/target,
	$main_menue/buttons/item,
]

@onready var SubUis: Array[Node2D] = [
	$ui/sub_ui/purify,
	$ui/sub_ui/soulimate, 
	$ui/sub_ui/target,
	$ui/sub_ui/items,
	$ui/sub_ui/win_screen,
]

@onready var AnimPlayer: AnimationPlayer = $anim_player
@onready var TweenInstance: Tween
@onready var AllButtons: Node2D = $main_menue/buttons
@onready var SpeedUp: AnimatedSprite2D = $main_menue/speed_up


func set_state(new_state: SUB_GAME_STATES) -> void:
	current_state = new_state
	
	_hide_ui()
	await ui_hidden
	
	SubUis[new_state].visible = true
	SubUis[new_state].process_mode = Node.PROCESS_MODE_INHERIT

func set_main_menue_input(current_button: int) -> void:
	
	MainMenueButtons[0].frame = 0
	MainMenueButtons[1].frame = 0
	MainMenueButtons[2].frame = 0
	MainMenueButtons[3].frame = 0
	
	match current_button:
		0:
			MainMenueButtons[0].frame = 1
		1:
			MainMenueButtons[1].frame = 1
		2:
			MainMenueButtons[2].frame = 1
		3: 
			MainMenueButtons[3].frame = 1

func set_sub_ui_input(event: InputEvent, sub_ui: int) -> void:
	
	if event.is_action_pressed("shift"):
		SubUis[sub_ui].visible = false
		SubUis[sub_ui].process_mode = Node.PROCESS_MODE_DISABLED
		_show_ui()


func set_speed_up() -> void:
	SpeedUp.visible = !SpeedUp.visible


func play_win_animation() -> void:

		AnimPlayer.play_backwards("start")
		await AnimPlayer.animation_finished
		win_animation_finished.emit()


func _ready() -> void:

	AnimPlayer.play("start")

func _hide_ui() -> void:

	TweenInstance = create_tween()
	TweenInstance.tween_property(AllButtons, "position", Vector2(0, 14), .15)
	await TweenInstance.finished
	await get_tree().create_timer(.125).timeout
	ui_hidden.emit()

func _show_ui() -> void:
	
	TweenInstance = create_tween()
	TweenInstance.tween_property(AllButtons, "position", Vector2(0, 0), 0.15)
