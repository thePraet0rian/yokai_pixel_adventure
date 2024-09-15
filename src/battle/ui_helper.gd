class_name UiHelper extends Node


signal start_battle
signal win_animation_finished
signal hide_ui
@warning_ignore("unused_signal")
signal heal_yokai
@warning_ignore("unused_signal")
signal ui_shown


enum SUB_GAME_STATES {
	PURIFY = 0, 
	SOULIMATE = 1, 
	TARGET = 2, 
	ITEM = 3, 
	NONE = 4,
}


var current_state: SUB_GAME_STATES = SUB_GAME_STATES.NONE
var player_yokais: Array[Yokai]
var player_back_arr: Array[BattleYokai]
var ui_hidden: bool = false
var is_started: bool = false


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

@onready var Medalls: Array[Sprite2D] = [
	$main_menue/medalls/Sprite2D,
	$main_menue/medalls/Sprite2D2,
	$main_menue/medalls/Sprite2D3,
]

@onready var UiAnimPlayer: AnimationPlayer = $AnimPlayer
@onready var TweenInstance: Tween
@onready var AllButtons: Node2D = $main_menue/buttons
@onready var SpeedUp: AnimatedSprite2D = $main_menue/speed_up

@onready var BattleInst: Battle = get_parent()
@onready var BattleYokaiHelperInstance: BattleYokaiHelper = BattleInst.YokaiHelperInstance

@onready var Start: Node2D = $Start


func _ready() -> void:
	_connect_signals()


func _input(event: InputEvent) -> void:
	if not is_started:
		if event.is_action_pressed("space"):
			start_battle.emit()
			UiAnimPlayer.play("start")
			is_started = true
			await UiAnimPlayer.animation_finished
			Start.visible = false
	

func _connect_signals() -> void:
	global.on_yokai_action_finished.connect(_on_yokai_action_finished)
	
	await get_parent().ready
	BattleYokaiHelperInstance = BattleInst.YokaiHelperInstance


#func _heal_yokai(_health: int) -> void:
	#heal_yokai.emit(_health)


func _hide_ui() -> void:
	TweenInstance = create_tween()
	TweenInstance.tween_property(AllButtons, "position", Vector2(0, 14), .15)
	await TweenInstance.finished
	await get_tree().create_timer(.125).timeout
	hide_ui.emit()


func _show_ui() -> void:	
	TweenInstance = create_tween()
	TweenInstance.tween_property(AllButtons, "position", Vector2(0, 0), 0.15)


func _update_ui() -> void:
	for i in range(len(player_back_arr)):
		if player_back_arr[i].YokaiInst.inspirited == true:
			Medalls[i].texture = load("res://res/yokai/jibanyan/jibanyan_medall.png")
		else:
			Medalls[i].texture = load("res://res/yokai/cadin/cadin_medall.png")
 			


func set_state(new_state: int) -> void:
	current_state = new_state as SUB_GAME_STATES
	
	_hide_ui()
	await hide_ui
	
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


func set_win_xp(xp: int) -> void:
	SubUis[4].set_win_xp(xp)


func set_player_yokai_arr(_player_yokais: Array[Yokai]) -> void:
	player_yokais = _player_yokais
	

func play_win_animation() -> void:
	UiAnimPlayer.play_backwards("start")
	await UiAnimPlayer.animation_finished
	win_animation_finished.emit()


func _on_yokai_action_finished() -> void:
	player_back_arr = BattleYokaiHelperInstance.get_player_back()
	_update_ui()
