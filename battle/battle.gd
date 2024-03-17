class_name battle
extends CanvasLayer


var player_team: Array = ["Dragon Lord", "Someguy", "Jibanyan", "Jibanyan", "Jibanyan", "Jibanyan"]
@onready var player_team_inst: Array = [$players/yokai, $players/yokai2, $players/yokai3]

var enemy_team: Array = ["Jibanyan", "Weird Bird", "Cadin", "", "", ""]
var enemy_team_inst: Array = []

var current_player_team_index: int = 0
var current_enemy_team_index: int = 0


func set_player(yokai : Array[global.Yokai]) -> void:
	
	print(yokai)
	print(yokai[0])
	print(yokai[0].health)


func set_enemy() -> void:
	pass


###############################################################################


@onready var ui_anim_player: AnimationPlayer = $ui/ui_anim_player


func _ready() -> void:
	
	setup_battle()


func setup_battle() -> void:
	
	pass


###############################################################################


@onready var buttons_anim: AnimationPlayer = $buttons/buttons_anim_player


enum GAME_STATES {MENUE= 0, TARGET = 1, SOULIMATE = 2, ITEM = 3, PURIFY = 4, NONE = 5}


var current_game_state: GAME_STATES =  GAME_STATES.MENUE


func _input(event: InputEvent) -> void:
	
	
	match current_game_state:
		
		0:
			menue_input(event)
		1:
			target_input(event)
		2:
			soulimate_input(event)
		3:
			item_input(event)
		4:
			purify_input(event)


@onready var players: Node2D = $players


var input_direction: Vector2 = Vector2.ZERO


func menue_input(event: InputEvent) -> void:
	
	
	if event.is_action_pressed("1"):
		current_game_state = GAME_STATES.PURIFY
	elif event.is_action_pressed("2"):
		current_game_state = GAME_STATES.SOULIMATE
	elif event.is_action_pressed("3"):
		current_game_state = GAME_STATES.TARGET
	elif event.is_action_pressed("4"):
		current_game_state = GAME_STATES.ITEM
	
	if event.is_action_pressed("left"):
		if item_button_entered: 
			current_game_state = GAME_STATES.ITEM
			print("item")
			
		elif target_button_entered:
			current_game_state = GAME_STATES.TARGET
			print("target")
			
		elif soulimate_button_entered:
			current_game_state = GAME_STATES.SOULIMATE
			print("soulimate")
			
		elif purify_button_entered:
			current_game_state = GAME_STATES.PURIFY
			print("purify")


func target_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.MENUE


func soulimate_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.MENUE


func item_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.MENUE


func purify_input(event: InputEvent) ->  void:
	
	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.MENUE


###############################################################################


var is_moving: bool = false
#var is_hidden: bool = false TODO: implement UI hiding


func player_input() -> void:
	
	input_direction.x = Input.get_axis("move_left", "move_right")
	
	if input_direction != Vector2.ZERO:
		
		is_moving = true
		
		if input_direction == Vector2.LEFT:
			
			move_yokai(MOVE.LEFT)
			
		elif input_direction == Vector2.RIGHT:
			
			move_yokai(MOVE.RIGHT)


const player_yokai_scn: PackedScene = preload("res://battle/battle_scenes/player_yokai.tscn")
const player_yokai_sprite: Array[Resource] = [preload("res://yokai/zerberker/zerberker_back.png"), preload("res://yokai/jibanyan/jibanyan.png"), preload("res://yokai/jibanyan/jibanyan_back.png"), preload("res://yokai/dargon_lord/dargon_lord_back.png"), preload("res://yokai/jibanyan/jibanyan_back.png"), preload("res://yokai/jibanyan/jibanyan_back.png")]


enum MOVE {LEFT = 0, RIGHT = 1}


var direction_move: Array[Vector2] = [Vector2.LEFT, Vector2.RIGHT]
var player_yokai_index: int = 0


func move_yokai(direction: MOVE) -> void: 
	
	
	var player_yokai_inst: Node2D = player_yokai_scn.instantiate()
	players.add_child(player_yokai_inst)
	
	if direction == MOVE.LEFT:
		
		player_yokai_inst.position = Vector2(264, 91)
		player_team_inst.append(player_yokai_inst)
		
		var tmp_index: int = (player_yokai_index + 3) % 6
		
		player_yokai_inst.texture = player_yokai_sprite[tmp_index]
		
		
		if player_yokai_index != 0:
			player_yokai_index -= 1
		else:
			player_yokai_index = 5
		
		
	elif direction == MOVE.RIGHT:
		
		player_yokai_inst.position = Vector2(-24, 91)
		player_team_inst.insert(0, player_yokai_inst)
		player_yokai_inst.texture = player_yokai_sprite[player_yokai_index]
		
		if player_yokai_index != 5:
			player_yokai_index += 1
		else:
			player_yokai_index = 0
	
	
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
		buttons_anim.play("buttons_show")
		#is_hidden = true
		test_2 = true
	
	is_moving = false


###############################################################################


var item_button_entered: bool = false
var target_button_entered: bool = false
var soulimate_button_entered: bool = false
var purify_button_entered: bool = false


func _on_item_button_mouse_entered() -> void:
	item_button_entered = true

func _on_item_button_mouse_exited() -> void:
	item_button_entered = false

func _on_target_button_mouse_entered() -> void:
	target_button_entered = true

func _on_target_button_mouse_exited() -> void:
	target_button_entered = false

func _on_soulimate_button_mouse_entered() -> void:
	soulimate_button_entered = true

func _on_soulimate_button_mouse_exited() -> void:
	soulimate_button_entered = false

func _on_purify_button_mouse_entered() -> void:
	purify_button_entered = true

func _on_purify_button_mouse_exited() -> void:
	purify_button_entered = false


###############################################################################


func _on_tick_timer_timeout() -> void:
	
	player_tick()
	enemy_tick()


func player_tick() -> void:
	
	print(is_moving)
	
	if not is_moving:
		
		print("yes")


func enemy_tick() -> void:
	
	if not is_moving:
		
		await create_tween().tween_property($enemies/enemy_center, "position", $enemies/enemy_center.position + Vector2(0, -18), .5).finished
		await create_tween().tween_property($enemies/enemy_center, "position", $enemies/enemy_center.position + Vector2(0, 18), .5).finished
