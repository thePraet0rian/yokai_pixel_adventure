class_name Battle extends CanvasLayer

# #############################################################################

var player_yokai_arr: Array[global.Yokai] = global.player_yokai

var enemy_team_arr: Array[global.Yokai] = [null]:
	set(value): _set_enemy(value)

func _set_enemy(value: Array) -> void:
	enemy_team_arr = value

# ############################################################################# 
 
@onready var player_team_inst: Array = [$players/yokai, $players/yokai2, $players/yokai3]

@onready var anim_player: AnimationPlayer = $anim_player
@onready var ui_anim_player: AnimationPlayer = $ui/main_ui/ui_anim_player
@onready var buttons_anim_player: AnimationPlayer = $buttons/buttons_anim_player

func _ready() -> void:
	setup_battle()

func setup_battle() -> void:
	anim_player.play("start")

# #############################################################################

enum GAME_STATES {MENUE = 0, SELECTING = 1, ACTION = 2}
enum SUB_GAME_STATES {TARGET = 0, SOULIMATE = 1, ITEM = 2, PURIFY = 3, NONE = 4}

var current_game_state: GAME_STATES = GAME_STATES.MENUE
var current_sub_game_state: SUB_GAME_STATES = SUB_GAME_STATES.TARGET

func _input(event: InputEvent) -> void:
	
	if current_game_state == GAME_STATES.MENUE:
		_menue_input(event)
	elif current_game_state == GAME_STATES.SELECTING:
		_selecting_input(event)
	elif current_game_state == GAME_STATES.ACTION:
		_action_input(event)

# #############################################################################

func _menue_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("tab"):
		current_game_state = GAME_STATES.SELECTING

@onready var buttons: Array[Sprite2D] = [$buttons/purify, $buttons/soulimate, $buttons/target, $buttons/item]

var buttons_index: int = 0

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
	
	for i in range(len(buttons)):
		if i == buttons_index:
			buttons[i].frame = 1
		else: 
			buttons[i].frame = 0
	
	if event.is_action_pressed("tab"):
		current_game_state = GAME_STATES.MENUE
		
		for i in range(len(buttons)):
			buttons[i].frame = 0
	
	if event.is_action_pressed("space"):
		
		current_game_state = GAME_STATES.ACTION
		current_sub_game_state = buttons_index as SUB_GAME_STATES
		_change_sub_game_state()

func _change_sub_game_state() -> void:
	
	match current_sub_game_state:
		
		SUB_GAME_STATES.PURIFY:
			purify.visible = true
		SUB_GAME_STATES.SOULIMATE:
			soulimate.visible = true
		SUB_GAME_STATES.ITEM:
			items.visible = true
		SUB_GAME_STATES.TARGET:
			target.visible = true

func _action_input(event: InputEvent) -> void:
	
	match current_sub_game_state:
		
		SUB_GAME_STATES.PURIFY:
			purify_input(event)
		SUB_GAME_STATES.SOULIMATE:
			soulimate_input(event)
		SUB_GAME_STATES.ITEM:
			item_input(event)
		SUB_GAME_STATES.TARGET:
			target_input(event)

@onready var items: Node2D = $ui/sub_ui/items
@onready var target: Node2D = $ui/sub_ui/target
@onready var soulimate: Node2D = $ui/sub_ui/soulimate
@onready var purify: Node2D = $ui/sub_ui/purify

var input_direction: Vector2 = Vector2.ZERO

func target_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.SELECTING
		target.visible = false

func soulimate_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("shift"):
		soulimate.visible = false
		current_game_state = GAME_STATES.SELECTING

func item_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.SELECTING
		items.visible = false

func purify_input(event: InputEvent) ->  void:
	
	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.SELECTING
		purify.visible = false

# #############################################################################

enum MOVE {LEFT = 0, RIGHT = 1}

var is_moving: bool = false
var direction_move: Array[Vector2] = [Vector2.LEFT, Vector2.RIGHT]

func player_input() -> void:
	
	input_direction.x = Input.get_axis("move_wheel_left", "move_wheel_right")
	
	if input_direction != Vector2.ZERO:
		is_moving = true
		
		if input_direction == Vector2.LEFT:
			move_yokai(MOVE.LEFT)
			
		elif input_direction == Vector2.RIGHT:
			move_yokai(MOVE.RIGHT)

const player_yokai_scn: PackedScene = preload("res://battle/battle_scenes/player_yokai.tscn")

@onready var players: Node2D = $players

func move_yokai(direction: MOVE) -> void: 
	
	var player_yokai_inst: Node2D = player_yokai_scn.instantiate()
	players.add_child(player_yokai_inst)
	
	if direction == MOVE.LEFT:
		
		player_yokai_inst.position = Vector2(264, 91)
		player_team_inst.append(player_yokai_inst)
		
		player_yokai_arr.append(player_yokai_arr[0])
		player_yokai_arr.remove_at(0)
		
		player_yokai_inst.texture = player_yokai_arr[2].front_sprite
	elif direction == MOVE.RIGHT:
		
		player_yokai_inst.position = Vector2(-24, 91)
		player_team_inst.insert(0, player_yokai_inst)
		
		player_yokai_arr.insert(0, player_yokai_arr[5])
		player_yokai_arr.remove_at(6)
		
		player_yokai_inst.texture = player_yokai_arr[0].front_sprite
	
	for i in range(4):
		
		player_team_inst[i].move_direction(direction_move[direction])
	
	if direction == MOVE.LEFT:
		
		remove_yokai(0)
	elif direction == MOVE.RIGHT:
		
		remove_yokai(3)

func remove_yokai(yokai: int) -> void:
	
	player_team_inst[yokai].remove()
	player_team_inst.remove_at(yokai)

func _physics_process(_delta: float) -> void:
	
	if player_team_inst[2].progress == 0.0:
		player_input()
		show_ui()

var test_2: bool = false

func show_ui() -> void:
	
	await get_tree().create_timer(.1).timeout
	
	if player_team_inst[2].progress != 0.0:
		return
	
	if not test_2: 
		buttons_anim_player.play("buttons_show")
		#is_hidden = true
		test_2 = true
	
	is_moving = false

# #############################################################################


func _on_tick_timer_timeout() -> void:
	
	player_tick()
	enemy_tick()

func player_tick() -> void:
	
	if not is_moving:
		pass

func enemy_tick() -> void:
	
	if not is_moving:
		await create_tween().tween_property($enemies/enemy_center, "position", $enemies/enemy_center.position + Vector2(0, -18), .5).finished
		await create_tween().tween_property($enemies/enemy_center, "position", $enemies/enemy_center.position + Vector2(0, 18), .5).finished




