class_name Battle extends CanvasLayer


enum GAME_STATES {
	SELECTING = 0,
	ACTION = 1,
	NONE = 2,
}

enum SUB_GAME_STATES {
	PURIFY = 0,
	SOULIMATE = 1,
	TARGET = 2,
	ITEM = 3,
	NONE = 4,
	WIN = 5,
}


var current_game_state: GAME_STATES = GAME_STATES.NONE
var current_sub_game_state: SUB_GAME_STATES = SUB_GAME_STATES.TARGET

var player_yokai_arr: Array[Yokai]
var enemy_yokai_arr: Array[Yokai]

var buttons_index: int = 0
var input_direction: Vector2 = Vector2.ZERO
var is_moving: bool = false

var can_soulimate: bool = true
var can_item: bool = true
var can_purfy: bool = true
var can_target: bool = true

var is_sped_up: bool = false


@onready var YokaiHelperInstance: BattleYokaiHelper = $yokai_helper
@onready var UiHelperInstance: UiHelper = $ui_helper 


func _ready() -> void:
	_setup_yokai_helper()
	_setup_ui_helper()	
	_connect_signals()


func _setup_yokai_helper() -> void:
	YokaiHelperInstance.set_player_yokai_arr(player_yokai_arr)
	YokaiHelperInstance.set_enemy_yokai_arr(enemy_yokai_arr)
	YokaiHelperInstance.setup_yokai()


func _setup_ui_helper() -> void:
	UiHelperInstance.set_player_yokai_arr(player_yokai_arr)


func _connect_signals() -> void:
	UiHelperInstance.start_battle.connect(_start_battle)
	UiHelperInstance.heal_yokai.connect(_heal_yokai)


func _start_battle() -> void:
	await get_tree().physics_frame
	current_game_state = GAME_STATES.SELECTING
	YokaiHelperInstance.set_yokai_tick(true)


func _heal_yokai(health: int) -> void:
	YokaiHelperInstance.set_heal(health)


func _input(event: InputEvent) -> void:
	match current_game_state:
		GAME_STATES.SELECTING:
			_selecting_input(event)
		GAME_STATES.ACTION:
			_action_input(event)


func _selecting_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left"):
		if buttons_index != 0:
			buttons_index -= 1
		else:
			buttons_index = 3
	elif event.is_action_pressed("move_right"):
		if buttons_index != 3:
			buttons_index += 1
		else:
			buttons_index = 0
	
	UiHelperInstance.set_main_menue_input(buttons_index)

	if event.is_action_pressed("space"):
		_change_sub_game_state(buttons_index)
	
	if event.is_action_pressed("speed_up"):
		UiHelperInstance.set_speed_up()
		if not is_sped_up:
			YokaiHelperInstance.set_speed(.5)
			is_sped_up = true
		else:
			YokaiHelperInstance.set_speed(2)
			is_sped_up = false


func _change_sub_game_state(sub_buttons_index: int) -> void:
	YokaiHelperInstance.set_yokai_tick(false)
	current_game_state = GAME_STATES.ACTION

	UiHelperInstance.set_state(sub_buttons_index)

	match sub_buttons_index:
		SUB_GAME_STATES.PURIFY:
			current_sub_game_state = SUB_GAME_STATES.PURIFY
		SUB_GAME_STATES.SOULIMATE:
			current_sub_game_state = SUB_GAME_STATES.SOULIMATE
			YokaiHelperInstance.set_soulimate_selected_yokai(0)
		SUB_GAME_STATES.TARGET:
			current_sub_game_state = SUB_GAME_STATES.TARGET
		SUB_GAME_STATES.ITEM:
			current_sub_game_state = SUB_GAME_STATES.ITEM


func _action_input(event: InputEvent) -> void:
	match current_sub_game_state:
		SUB_GAME_STATES.PURIFY:
			_purify_input(event)
		SUB_GAME_STATES.SOULIMATE:
			_soulimate_input(event)
		SUB_GAME_STATES.TARGET:
			_target_input(event)
		SUB_GAME_STATES.ITEM:
			_item_input(event)
		SUB_GAME_STATES.WIN:
			_win_input(event)


func _purify_input(event: InputEvent) ->  void:
	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.SELECTING

		UiHelperInstance.set_sub_ui_input(event, 0)
		YokaiHelperInstance.set_yokai_tick(true)


func _soulimate_input(event: InputEvent) -> void:
	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.SELECTING

		UiHelperInstance.set_sub_ui_input(event, 1)
		YokaiHelperInstance.set_yokai_tick(true)
		YokaiHelperInstance.disable_soulimate_ui()


func _target_input(event: InputEvent) -> void:
	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.SELECTING

		UiHelperInstance.set_sub_ui_input(event, 2)
		YokaiHelperInstance.set_yokai_tick(true)


func _item_input(event: InputEvent) -> void:
	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.SELECTING

		UiHelperInstance.set_sub_ui_input(event, 3)
		YokaiHelperInstance.set_yokai_tick(true)


func _calculate_win_xp() -> int:
	return 100


func _win_input(event: InputEvent) -> void:
	if event.is_action_pressed("space"):
		pass


func _physics_process(_delta: float) -> void:
	if YokaiHelperInstance.player_team_inst_front[2].progress == 0.0:
		if YokaiHelperInstance.yokai_finished_moving:
			if current_game_state == GAME_STATES.SELECTING:
				_player_input()


func _player_input() -> void:
	input_direction.x = Input.get_axis("move_wheel_left", "move_wheel_right")

	if input_direction != Vector2.ZERO:
		is_moving = true
		if input_direction == Vector2.LEFT:
			YokaiHelperInstance.move_yokai(0)
		elif input_direction == Vector2.RIGHT:
			YokaiHelperInstance.move_yokai(1)
	else:
		is_moving = false



func set_player_yokai(player_yokais: Array) -> void:
	player_yokai_arr = player_yokais


func set_enemy_yokai(enemy_yokais: Array) -> void:
	enemy_yokai_arr = enemy_yokais


func update_battle_conditions() -> void:
	var count: int = 0

	for i in range(len(YokaiHelperInstance.enemy_team_inst_front)):
		if YokaiHelperInstance.enemy_team_inst_front[i].YokaiInst.yokai_hp <= 0:
			count += 1

	if count == 3:
		UiHelperInstance.play_win_animation()
		UiHelperInstance.set_state(4)
		UiHelperInstance.set_win_xp(_calculate_win_xp())

		await UiHelperInstance.win_animation_finished
		YokaiHelperInstance.set_yokai_tick(false)
		current_game_state = GAME_STATES.ACTION
		current_sub_game_state = SUB_GAME_STATES.WIN
