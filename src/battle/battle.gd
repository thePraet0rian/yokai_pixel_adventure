class_name Battle extends CanvasLayer


enum GAME_STATES {
	SELECTING = 1, 
	ACTION = 2, 
	WIN = 3,
}

enum SUB_GAME_STATES {
	PURIFY = 0, 
	SOULIMATE = 1, 
	TARGET = 2, 
	ITEM = 3, 
	NONE = 4,
}

enum {
	LEFT = 0, 
	RIGHT = 1,
}


@onready var AnimPlayer: AnimationPlayer = $anim_player

@onready var Purify: Node2D = $ui/sub_ui/purify
@onready var Soulimate: Node2D = $ui/sub_ui/soulimate
@onready var Target: Node2D = $ui/sub_ui/target
@onready var Items: Node2D = $ui/sub_ui/items

@onready var SoulimateButton: Sprite2D = $buttons/soulimate

@onready var ButtonA: Node2D = $buttons
@onready var Buttons: Array[Sprite2D] = [
	$buttons/purify,
	$buttons/soulimate,
	$buttons/target,
	$buttons/item,
]

@onready var MedallsA: Node = $medalls
@onready var Medalls: Array[Sprite2D] = [
	$medalls/Sprite2D,
	$medalls/Sprite2D2, 
	$medalls/Sprite2D3
]

@onready var BattleYokaiHelper: YokaiHelper = $yokai

@onready var WinScreen: Node2D = $win_screen
@onready var WinScreenAnimPlayer: AnimationPlayer = $win_screen/anim_player


var current_game_state: GAME_STATES = GAME_STATES.SELECTING
var current_sub_game_state: SUB_GAME_STATES = SUB_GAME_STATES.TARGET

var player_yokai_arr: Array[Yokai]
var enemy_yokai_arr: Array[Yokai]

var buttons_index: int = 0

var input_direction: Vector2 = Vector2.ZERO

var is_targeting: bool = false
var targeting_int: int = 0

var direction_move: Array[Vector2] = [Vector2.LEFT, Vector2.RIGHT]
var is_moving: bool = false

var can_soulimate: bool = true
var can_item: bool = true
var can_purfy: bool = true
var can_target: bool = true

var selected_yokai: int


# START # -----------------------------------------------------------------------------------------


func _ready() -> void:	
	
	AnimPlayer.play("start")
	
	BattleYokaiHelper.set_player_yokai_arr(player_yokai_arr)
	BattleYokaiHelper.set_enemy_yokai_arr(enemy_yokai_arr)
	BattleYokaiHelper.setup_yokai()


# INPUT # -----------------------------------------------------------------------------------------


func _input(event: InputEvent) -> void:
		
	match current_game_state:
		GAME_STATES.SELECTING:
			_selecting_input(event)
		GAME_STATES.ACTION:
			_action_input(event)
		GAME_STATES.WIN:
			_win_input(event)


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

	Buttons[0].frame = 0
	Buttons[1].frame = 0
	Buttons[2].frame = 0
	Buttons[3].frame = 0
	
	match buttons_index:
		0:
			Buttons[0].frame = 1
		
		1:
			if _can_soulimate(): 
				Buttons[1].frame = 1
			else:
				print("yes")
				Buttons[1].frame = 3
		2:
			Buttons[2].frame = 1
		
		3: 
			Buttons[3].frame = 1
		
	if event.is_action_pressed("space"):
		_change_sub_game_state(buttons_index)


func _change_sub_game_state(sub_buttons_index: int) -> void:
	
	BattleYokaiHelper.disable_yokai()
	
	match sub_buttons_index:
		SUB_GAME_STATES.PURIFY:
			Purify.visible = true
			current_game_state = GAME_STATES.ACTION
			
		SUB_GAME_STATES.SOULIMATE:
			if _can_soulimate():
				Soulimate.visible = true
				Soulimate.process_mode = Node.PROCESS_MODE_INHERIT
			
		SUB_GAME_STATES.TARGET:
			_hide_ui()
			Target.visible = true
			Target.process_mode = Node.PROCESS_MODE_INHERIT
			current_game_state = GAME_STATES.ACTION
			current_sub_game_state = SUB_GAME_STATES.TARGET
			
		SUB_GAME_STATES.ITEM:
			_hide_ui()
			Items.visible = true
			Items.process_mode = Node.PROCESS_MODE_INHERIT
			current_game_state = GAME_STATES.ACTION
			current_sub_game_state = SUB_GAME_STATES.ITEM


func _can_soulimate() -> bool:
	
	#for i in range(len(player_team_inst)):
		#if player_team_inst[i].YokaiInst.yokai_soul >= 1.0:
			#print("soulimate")
	return true


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


func _purify_input(event: InputEvent) ->  void:

	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.SELECTING
		Purify.visible = false
		BattleYokaiHelper.enable_yokai()
		_show_ui()


func _soulimate_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.SELECTING
		Soulimate.visible = false
		BattleYokaiHelper.enable_yokai()


func _target_input(event: InputEvent) -> void:

	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.SELECTING
		Target.visible = false
		Target.process_mode = Node.PROCESS_MODE_DISABLED
		BattleYokaiHelper.enable_yokai()
		_show_ui()


func set_selected_yokai(_yokai_number: int) -> void:
	
	#for i in range(len(enemy_team_inst)):
		#if yokai_number != i:
			#enemy_team_inst[i].selector.visible = false
	pass

		
func _item_input(event: InputEvent) -> void:

	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.SELECTING
		Items.visible = false
		BattleYokaiHelper.enable_yokai()
		_show_ui()
		Items.process_mode = Node.PROCESS_MODE_DISABLED


# MOVE # ------------------------------------------------------------------------------------------


func _physics_process(_delta: float) -> void:

	if BattleYokaiHelper.player_team_inst_front[2].progress == 0.0:
		_player_input()


func _player_input() -> void:

	input_direction.x = Input.get_axis("move_wheel_left", "move_wheel_right")

	if input_direction != Vector2.ZERO:
		
		is_moving = true
		
		if input_direction == Vector2.LEFT:
			
			BattleYokaiHelper.move_yokai(0)
		elif input_direction == Vector2.RIGHT:
			
			BattleYokaiHelper.move_yokai(1)
	else:
		is_moving = false


# ACTION # ----------------------------------------------------------------------------------------


func update_battle_conditions() -> void:
	
	var count: int = 0
	
	for i in range(len(BattleYokaiHelper.enemy_team_inst_front)):
		if BattleYokaiHelper.enemy_team_inst_front[i].YokaiInst.yokai_hp <= 0:
			count += 1
	
	if count == 3:
		
		AnimPlayer.play_backwards("start")
		await AnimPlayer.animation_finished
		
		WinScreen.visible = true
		BattleYokaiHelper.disable_yokai()
		current_game_state = GAME_STATES.WIN


# MISC # ------------------------------------------------------------------------------------------


func _win_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("space"):
		print("yes")
		WinScreenAnimPlayer.play("fade")


func _end() -> void:
	
	get_parent().process_mode = Node.PROCESS_MODE_INHERIT
	await get_tree().physics_frame
	global.on_battle_ended.emit()
	queue_free()


func _hide_ui() -> void:
	
	var tween: Tween = create_tween()
	tween.tween_property(ButtonA, "position", Vector2(0, 14), .15)


func _show_ui() -> void:
	
	var tween: Tween = create_tween()
	tween.tween_property(ButtonA, "position", Vector2(0, 0), 0.15)


func _update_medalls() -> void:
	
	pass

# -------------------------------------------------------------------------------------------------
