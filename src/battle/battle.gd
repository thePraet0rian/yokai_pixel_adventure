class_name Battle extends CanvasLayer


const battle_yokai_scn: PackedScene = preload("res://scn/battle/battle_yokai.tscn")

var player_yokai_arr: Array[Yokai]
var enemy_yokai_arr: Array[Yokai]

var player_team_inst: Array[BattleYokai]
var enemy_team_inst: Array[BattleYokai]

var is_boss: bool = false

@onready var anim_player: AnimationPlayer = $anim_player
@onready var ui_anim_player: AnimationPlayer = $ui/main_ui/ui_anim_player
@onready var buttons_anim_player: AnimationPlayer = $buttons/buttons_anim_player


func _ready() -> void:
	
	setup_players()
	setup_enemys()
	
	global._on_yokai_action.connect(_on_yokai_action)
	
	anim_player.play("start")


func setup_players() -> void:
	
	for i in range(0, 3):
		
		var BattleYokaiInst: BattleYokai = battle_yokai_scn.instantiate()
		player_team_inst.append(BattleYokaiInst)
		
		BattleYokaiInst.position = Vector2(48, 91) + Vector2(72, 0) * i
		BattleYokaiInst.YokaiInst = player_yokai_arr[i]
		BattleYokaiInst.update("player")
		players.add_child(player_team_inst[i])


func setup_enemys() -> void:
	
	for i in range(0, 3):
		
		var BattleYokaiInst: Sprite2D = battle_yokai_scn.instantiate()
		enemy_team_inst.append(BattleYokaiInst)

		BattleYokaiInst.position = Vector2(48, 40) + Vector2(72, 0) * i
		BattleYokaiInst.YokaiInst = enemy_yokai_arr[i]
		BattleYokaiInst.update("enemy")
		enemies.add_child(enemy_team_inst[i])


enum GAME_STATES {MENUE = 0, SELECTING = 1, ACTION = 2, WIN}
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
	elif current_game_state == GAME_STATES.WIN:
		_win_input(event)


func _menue_input(event: InputEvent) -> void:

	if event.is_action_pressed("tab"):
		current_game_state = GAME_STATES.SELECTING
		_disable_yokai()


var buttons_index: int = 0

@onready var buttons: Array[Sprite2D] = [
	$buttons/purify,
	$buttons/soulimate,
	$buttons/target,
	$buttons/item,
]


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
		_enable_yokai()

		for i in range(len(buttons)):
			buttons[i].frame = 0

	if event.is_action_pressed("space"):

		_change_sub_game_state(buttons_index)


@onready var overlay_rect: ColorRect = $ui/main_ui/ColorRect


func _win_input(event: InputEvent) -> void:

	if event.is_action_pressed("space"):
		overlay_rect.visible = true
		ui_anim_player.play("fade_in")


func end() -> void:

	global._on_battle_end.emit()
	get_tree().paused = false
	queue_free()


func _change_sub_game_state(sub_buttons_index: int) -> void:

	match sub_buttons_index:
		0:
			for i in range(len(player_team_inst)):
				if player_team_inst[i].dirty:
					purify.visible = true
			
			return
			
		1:
			for i in range(len(player_team_inst)):
				if player_team_inst[i].YokaiInst.yokai_soul:
					soulimate.visible = true
					current_game_state = GAME_STATES.ACTION
					current_sub_game_state = SUB_GAME_STATES.SOULIMATE
			return
			
		2:
			target.visible = true
			current_game_state = GAME_STATES.ACTION
			current_sub_game_state = SUB_GAME_STATES.TARGET
			
		3:
			items.visible = true
			current_game_state = GAME_STATES.ACTION
			current_sub_game_state = SUB_GAME_STATES.ITEM


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

@onready var target_spr: Sprite2D = $ui/main_ui/target

var input_direction: Vector2 = Vector2.ZERO
var target_vec: Vector2 = Vector2.ZERO
var is_targeting : bool = false
var targeting_int: int = 0


func target_input(event: InputEvent) -> void:

	target_spr.visible = true
	target_spr.position = Vector2(48, 32) + Vector2(72, 0) * targeting_int

	if event.is_action_pressed("move_left"):
		if targeting_int > 0:
			targeting_int -= 1
	if event.is_action_pressed("move_right"):
		if targeting_int < 2:
			targeting_int += 1
	
	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.SELECTING
		target.visible = false
		#tick_timer.start()
	if event.is_action_pressed("space"):
		is_targeting = true
		targeting_int = 0


func soulimate_input(event: InputEvent) -> void:

	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.SELECTING
		soulimate.visible = false
		#tick_timer.start()


func item_input(event: InputEvent) -> void:

	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.SELECTING
		items.visible = false
		#tick_timer.start()


func purify_input(event: InputEvent) ->  void:

	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.SELECTING
		purify.visible = false
		#tick_timer.start()


enum MOVE {LEFT = 0, RIGHT = 1}

var direction_move: Array[Vector2] = [Vector2.LEFT, Vector2.RIGHT]
var is_moving: bool = false


func player_input() -> void:

	input_direction.x = Input.get_axis("move_wheel_left", "move_wheel_right")

	if input_direction != Vector2.ZERO:
		is_moving = true
		if input_direction == Vector2.LEFT:
			move_yokai(MOVE.LEFT)
		elif input_direction == Vector2.RIGHT:
			move_yokai(MOVE.RIGHT)
	else:
		is_moving = false


@onready var players: Node2D = $players
@onready var enemies: Node2D = $enemies


func move_yokai(direction: MOVE) -> void:

	if direction == MOVE.LEFT:
		move_left()
	elif direction == MOVE.RIGHT:
		move_right()

	for i in range(4):
		player_team_inst[i].move_direction(direction_move[direction])

	if direction == MOVE.LEFT:
		remove_yokai(0)
	elif direction == MOVE.RIGHT:
		remove_yokai(3)


func inst_yokai() -> Node2D:

	var player_yokai_inst: BattleYokai = battle_yokai_scn.instantiate()
	players.add_child(player_yokai_inst)

	return player_yokai_inst


func move_left() -> void:

	var player_yokai_inst: BattleYokai = inst_yokai()
	player_yokai_inst.position = Vector2(264, 91)

	player_team_inst.append(player_yokai_inst)

	player_yokai_arr.append(player_yokai_arr[0])
	player_yokai_arr.remove_at(0)

	player_yokai_inst.YokaiInst = player_yokai_arr[2]
	player_yokai_inst.update("player")


func move_right() -> void:

	var player_yokai_inst: Node2D = inst_yokai()
	player_yokai_inst.position = Vector2(-24, 91)
	
	player_team_inst.insert(0, player_yokai_inst)

	player_yokai_arr.insert(0, player_yokai_arr[5])
	player_yokai_arr.remove_at(6)

	player_yokai_inst.YokaiInst = player_yokai_arr[0]
	player_yokai_inst.update("player")


func remove_yokai(yokai: int) -> void:

	player_team_inst[yokai].remove()
	player_team_inst.remove_at(yokai)


func _physics_process(_delta: float) -> void:

	if player_team_inst[2].progress == 0.0:
		player_input()


func _on_yokai_action(team: int, yokai: int, action: String) -> void:

	match action:
		"attack":
			attack(team, yokai)


func attack(team: int, _yokai: int) -> void:

	match team:
		0:
			var random_int: int = pick_alive()

			enemy_team_inst[random_int].YokaiInst.yokai_hp -= calc_damage(0, 0, 0)
			enemy_team_inst[random_int].health_update()

			update_battle()
		1:
			pass


func pick_alive() -> int:

	if is_targeting:
		return targeting_int
	else:
		randomize()
		var random_int: int = randi_range(0, 2)

		if enemy_team_inst[0].YokaiInst.yokai_hp <= 0:
			if enemy_team_inst[1].YokaiInst.yokai_hp <= 0:
				if enemy_team_inst[2].YokaiInst.yokai_hp <= 0:
					return -1

		if enemy_team_inst[random_int].YokaiInst.yokai_hp <= 0:
			return pick_alive()

		return random_int


func calc_damage(_yokai_str: int, _yokai_def: int, _power: int) -> int:

	return 100
	
	#var crit: float = 1.0
	#var guard: float = 1.0
	
	#return ((yokai_str / 2 - yokai_def / 4) + (power / 2)) * crit * guard


@onready var win_screen: Node2D = $win_screen


func update_battle() -> void:
	
	if pick_alive() == -1:
		
		await get_tree().create_timer(1).timeout
		anim_player.play_backwards("start")
		await anim_player.animation_finished
		
		win_screen.visible = true
		_disable_yokai()
		current_game_state = GAME_STATES.WIN


func _disable_yokai() -> void:
	for i in range(3):
		player_team_inst[i].disable_tick()
		enemy_team_inst[i].disable_tick()


func _enable_yokai() -> void:
	for i in range(3):
		player_team_inst[i].enable_tick()
		enemy_team_inst[i].enable_tick()



