class_name Battle
extends CanvasLayer


@onready var player_team_inst: Array = [$players/yokai, $players/yokai2, $players/yokai3]

var player_yokai_arr: Array[global.Yokai]

var enemy_team: Array = ["Jibanyan", "Weird Bird", "Cadin", "", "", ""]
var enemy_team_inst: Array = []


func set_player(_yokai_arr : Array[global.Yokai]) -> void:
	player_yokai_arr = _yokai_arr


func set_enemy() -> void:
	pass


###############################################################################


@onready var ui_anim_player: AnimationPlayer = $ui/ui_anim_player


func _ready() -> void:
	
	setup_battle()


func setup_battle() -> void:
	
	print("setup_battle")


###############################################################################


enum GAME_STATES {MENUE = 0, TARGET = 1, SOULIMATE = 2, ITEM = 3, PURIFY = 4, NONE = 5}


@onready var buttons_anim: AnimationPlayer = $buttons/buttons_anim_player


var current_game_state: GAME_STATES =  GAME_STATES.MENUE


func _input(event: InputEvent) -> void:
	
	match current_game_state:
		
		GAME_STATES.MENUE:
			menue_input(event)
		
		GAME_STATES.TARGET:
			target_input(event)
		
		GAME_STATES.SOULIMATE:
			soulimate_input(event)
		
		GAME_STATES.ITEM:
			item_input(event)
		
		GAME_STATES.PURIFY:
			purify_input(event)


###############################################################################


@onready var items: Node2D = $Node/items
@onready var target: Node2D = $Node/target
@onready var soulimate: Node2D = $Node/soulimate
@onready var purify: Node2D = $Node/purify


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
			items.visible = true
			print("item")
		
		elif target_button_entered:
			current_game_state = GAME_STATES.TARGET
			target.visible = true
			print("target")
		
		elif soulimate_button_entered:
			current_game_state = GAME_STATES.SOULIMATE
			soulimate.visible = true
			print("soulimate")
			
		elif purify_button_entered:
			current_game_state = GAME_STATES.PURIFY
			purify.visible = true
			print("purify")


func target_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.MENUE
		target.visible = false


func soulimate_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.MENUE
		soulimate.visible = false


func item_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.MENUE
		items.visible = false


func purify_input(event: InputEvent) ->  void:
	
	if event.is_action_pressed("shift"):
		current_game_state = GAME_STATES.MENUE
		purify.visible = false


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


enum MOVE {LEFT = 0, RIGHT = 1}


@onready var players: Node2D = $players


var direction_move: Array[Vector2] = [Vector2.LEFT, Vector2.RIGHT]
var player_yokai_index: int = 0


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
	
	#print(is_moving)
	
	if not is_moving:
		
		#print("yes")
		pass


func enemy_tick() -> void:
	
	if not is_moving:
		
		await create_tween().tween_property($enemies/enemy_center, "position", $enemies/enemy_center.position + Vector2(0, -18), .5).finished
		await create_tween().tween_property($enemies/enemy_center, "position", $enemies/enemy_center.position + Vector2(0, 18), .5).finished
