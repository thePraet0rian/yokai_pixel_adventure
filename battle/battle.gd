class_name battle
extends CanvasLayer


var player_team: Array = ["Dragon Lord", "Someguy", "Jibanyan", "Jibanyan", "Jibanyan", "Jibanyan"]
@onready var player_team_inst: Array = [$players/yokai, $players/yokai2, $players/yokai3]

var enemy_team: Array = ["Jibanyan", "Weird Bird", "Cadin", "", "", ""]
var enemy_team_inst: Array = []

var current_player_team_index: int = 0
var current_enemy_team_index: int = 0


###############################################################################


@onready var ui_anim_player: AnimationPlayer = $ui/ui_anim_player


func _ready() -> void:
	
	print("wasdf")
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
	
	print("target")
	
	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.MENUE


func soulimate_input(event: InputEvent) -> void:
	
	print("soulimate")
	
	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.MENUE


func item_input(event: InputEvent) -> void:
	
	print("item")
	
	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.MENUE


func purify_input(event: InputEvent) ->  void:
	
	print("purify")
	
	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.MENUE


###############################################################################


const TILE_SIZE: Vector2 = Vector2(72, 0)

var progress: float = 0.0
var last_position: Vector2 = Vector2(0, -12)
var walk_speed: float = 6.0
var is_moving: bool = false


func _physics_process(delta: float) -> void:
	
	if not is_moving:
		player_input()
	elif input_direction != Vector2.ZERO and is_moving:
		move(delta)
	else:
		is_moving = false


var is_hidden: bool = false

const player_yokai: PackedScene = preload("res://battle/battle_scenes/player_yokai.tscn")


func player_input() -> void:
	
	input_direction.x = Input.get_axis("move_left", "move_right")
	
	if input_direction != Vector2.ZERO:
		
		last_position = players.position
		is_moving = true
		
		if input_direction == Vector2.LEFT:
			
			var player_yokai_inst: Node2D = player_yokai.instantiate()
			player_yokai_inst.position = Vector2(248, 92) + Vector2(72, 0) * current_player_team_index
			players.add_child(player_yokai_inst)
			
			player_team_inst.append(player_yokai_inst)
			player_team_inst[0].queue_free()
			player_team_inst.remove_at(0)
			
			current_player_team_index -= 1
			
			print(player_team_inst)
			
		elif input_direction == Vector2.RIGHT:
			
			var player_yokai_inst: Node2D = player_yokai.instantiate()
			player_yokai_inst.position = Vector2(-24, 92) + Vector2(-72, 0) * current_player_team_index
			players.add_child(player_yokai_inst)
			
			player_team_inst.insert(0, player_yokai_inst)
			player_team_inst[3].queue_free()
			player_team_inst.remove_at(player_team_inst.size() - 1)
			
			current_player_team_index += 1
			
			print(player_team_inst)
		
		
		
		if not is_hidden:
			buttons_anim.play("buttons_hide")
			is_hidden = true


func move(delta: float) -> void:
	
	progress += delta * walk_speed 
	
	if input_direction != Vector2.ZERO:
		
		if progress >= 1.0:
			players.position = last_position + (TILE_SIZE * input_direction)
			progress = 0.0
			is_moving = false
			
		else:
			players.position = last_position + (TILE_SIZE * input_direction * progress)


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
	pass # Replace with function body.
