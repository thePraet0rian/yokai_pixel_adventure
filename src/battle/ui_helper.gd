class_name UiHelper extends Node



signal win_animation_finished

signal hide_ui
signal ui_shown


enum SUB_GAME_STATES {
	PURIFY = 0, 
	SOULIMATE = 1, 
	TARGET = 2, 
	ITEM = 3, 
	NONE = 4,
}


var player_yokais: Array[Yokai]
var player_back_arr: Array[BattleYokai]

var current_state: SUB_GAME_STATES = SUB_GAME_STATES.NONE

var ui_hidden: bool = false
var is_started: bool = false
var first_animation_run: bool = false


@onready var MainMenueButtons: Array[Sprite2D] = [
	$HeadsUpDisplay/MenueButtons/PurifyButton,
	$HeadsUpDisplay/MenueButtons/SoulimateButton,
	$HeadsUpDisplay/MenueButtons/TargetButton,
	$HeadsUpDisplay/MenueButtons/ItemButton,
]

@onready var SubUis: Array[Node2D] = [
	$SubUserInterfaces/Purify,
	$SubUserInterfaces/Soulimate, 
	$SubUserInterfaces/Target,
	$SubUserInterfaces/Items,
	$SubUserInterfaces/WinScreen,
]

@onready var Medalls: Array[Sprite2D] = [
	$HeadsUpDisplay/Medalls/FirstMedall,
	$HeadsUpDisplay/Medalls/SecondMedall,
	$HeadsUpDisplay/Medalls/ThirdMedall,
]

@onready var TweenInstance: Tween

@onready var Start: Node2D = $Start
@onready var StartAnimPlayer: AnimationPlayer = $Start/StartAnimationPLayer

@onready var SubUserInterfaces: Node2D = $SubUserInterfaces

@onready var HudAnimPlayer: AnimationPlayer = $HeadsUpDisplay/HudAnimationPlayer
@onready var MenueButtonAnimPlayer: AnimationPlayer = $HeadsUpDisplay/MenueButtons/ButtonAnimPlayer

@onready var MenueButtons: Node2D =  $HeadsUpDisplay/MenueButtons
@onready var SpeedUp: AnimatedSprite2D = $HeadsUpDisplay/SpeedUp




func _ready() -> void:
	_connect_signals()


func _connect_signals() -> void:
	global.on_yokai_action_finished.connect(_on_yokai_action_finished)
	GlobalBattle.disable_ui.connect(_show_ui)


func _input(event: InputEvent) -> void:
	if not is_started and first_animation_run:
		_start(event)


func _start(event: InputEvent) -> void:
	if event.is_action_pressed("space"):
		StartAnimPlayer.play("start")
		is_started = true
		
		await StartAnimPlayer.animation_finished
		GlobalBattle.start_battle.emit()
		MenueButtonAnimPlayer.play("show_menue_buttons")
		
		Start.visible = false
		HudAnimPlayer.play("constant")



func _hide_ui() -> void:
	TweenInstance = create_tween()
	TweenInstance.tween_property(MenueButtons, "position", Vector2(0, 14), .15)
	await TweenInstance.finished
	hide_ui.emit()


func _show_ui(_a: int) -> void:
	TweenInstance = create_tween()
	TweenInstance.tween_property(MenueButtons, "position", Vector2(0, 0), 0.15)
	await TweenInstance.finished
	ui_shown.emit()


func _update_ui() -> void:
	for i in range(len(player_back_arr)):
		if player_back_arr[i].YokaiInst.inspirited == true:
			Medalls[i].texture = load("res://res/yokai/jibanyan/jibanyan_medall.png")
		else:
			Medalls[i].texture = load("res://res/yokai/cadin/cadin_medall.png")


func _on_yokai_action_finished() -> void:
	player_back_arr = YokaiHelper.get_player_back_arr()
	_update_ui()


func _on_start_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "autoplay_start":
		first_animation_run = true





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


func set_speed_up() -> void:
	SpeedUp.visible = !SpeedUp.visible


func set_win_xp(xp: int) -> void:
	SubUis[4].set_win_xp(xp)


func set_player_yokai_arr(_player_yokais: Array[Yokai]) -> void:
	player_yokais = _player_yokais


func play_win_animation() -> void:
	StartAnimPlayer.play_backwards("start")
	await StartAnimPlayer.animation_finished
	win_animation_finished.emit()
