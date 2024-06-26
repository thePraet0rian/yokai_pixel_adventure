class_name YokaiHelper extends Node


const BATTLE_YOKAI_SCENE: PackedScene = preload("res://scn/battle/battle_yokai.tscn")
const DIRECTION_MOVE: Array[Vector2] = [Vector2.LEFT, Vector2.RIGHT]

var player_yokai_arr: Array[Yokai]
var enemy_yokai_arr: Array[Yokai]

var player_team_inst_front: Array[BattleYokai]
var player_team_inst_back: Array[BattleYokai]

var enemy_team_inst_front: Array[BattleYokai]

var input_direction: Vector2 = Vector2.ZERO

var is_moving: bool = false
var yokai_finished_moving: bool = true


@onready var Players: Node2D = $players
@onready var Enemies: Node2D = $enemies
@onready var Parent: Battle = get_parent()


# READY # -----------------------------------------------------------------------------------------


func _ready() -> void:
	
	global.on_yokai_action.connect(on_yokai_action)


# SETUP # -----------------------------------------------------------------------------------------


func set_player_yokai_arr(arr: Array) -> void:
	
	player_yokai_arr = arr

func set_enemy_yokai_arr(arr: Array) -> void:
	
	enemy_yokai_arr = arr 


func setup_yokai() -> void:
	
	_setup_players()
	_setup_enemies()


func _setup_players() -> void:
	
	for i in range(3):
		
		var BattleYokaiInst: BattleYokai = BATTLE_YOKAI_SCENE.instantiate()
		player_team_inst_front.append(BattleYokaiInst)
		
		BattleYokaiInst.position = Vector2(48, 91) + Vector2(72, 0) * i
		BattleYokaiInst.YokaiInst = player_yokai_arr[i]
		BattleYokaiInst.update("player")
		Players.add_child(player_team_inst_front[i])
	
	for i in range(3, 6):
		
		var BattleYokaiInst: BattleYokai = BATTLE_YOKAI_SCENE.instantiate()
		player_team_inst_back.append(BattleYokaiInst)
		
		BattleYokaiInst.position = Vector2(-200, -200)
		BattleYokaiInst.YokaiInst = player_yokai_arr[i]
		BattleYokaiInst.update("Player")
		Players.add_child(BattleYokaiInst)
		
		BattleYokaiInst.disable_tick()


func _setup_enemies() -> void:
	
	for i in range(3):
		
		var BattleYokaiInst: Sprite2D = BATTLE_YOKAI_SCENE.instantiate()
		enemy_team_inst_front.append(BattleYokaiInst)

		BattleYokaiInst.position = Vector2(48, 40) + Vector2(72, 0) * i
		BattleYokaiInst.YokaiInst = enemy_yokai_arr[i]
		
		BattleYokaiInst.yokai_number = i
		BattleYokaiInst.update("enemy")
		
		Enemies.add_child(BattleYokaiInst)


# PURFIY # ----------------------------------------------------------------------------------------


func set_selected_yokai(yokai_number: int) -> void:
	
	for i in range(len(enemy_team_inst_front)):
		if yokai_number != i:
			enemy_team_inst_front[i].selector.visible = false


# MOVE YOKAI # ------------------------------------------------------------------------------------


func move_yokai(dir: int) -> void:
	
	yokai_finished_moving = false
	
	if dir == 0:
		_move_left()
	elif dir == 1:
		_move_right()
	
	for i in range(len(player_team_inst_front)):
		player_team_inst_front[i].move_direction(DIRECTION_MOVE[dir])
	
	if dir == 0:
		player_team_inst_front.remove_at(0)
		player_team_inst_back.remove_at(3)
	elif dir == 1:
		player_team_inst_front.remove_at(3)
		player_team_inst_back.remove_at(0)
	
	Parent.update_medalls()	
	

func _move_left() -> void:
	
	var new_yokai: Node2D = player_team_inst_back[2]
	new_yokai.position = Vector2(264, 91)
	new_yokai.enable_tick()

	player_team_inst_front.append(new_yokai)
	player_team_inst_back.insert(0, player_team_inst_front[0])
	player_team_inst_back[0].disable_tick()

	new_yokai.update("player")


func _move_right() -> void:
	
	var new_yokai: Node2D = player_team_inst_back[0]
	new_yokai.position = Vector2(-24, 91)
	new_yokai.enable_tick()

	player_team_inst_front.insert(0, new_yokai)
	player_team_inst_back.append(player_team_inst_front[3])
	player_team_inst_back[3].disable_tick()

	new_yokai.update("player")


# ACTIONS # ---------------------------------------------------------------------------------------	


func on_yokai_action(team: int, yokai: int, action: String) -> void:
	
	match action: 
		
		"attack":
			attack(team, yokai)


func attack(team: int, _yokai: int) -> void:
	
	match team:
		0:
			enemy_team_inst_front[yokai_ai(team)].health_update(100)
		1:
			pass
	
	Parent.update_battle_conditions()



func yokai_ai(team: int) -> int:
	
	match team:
		0:
			return randi_range(0, 2)
		1:
			pass
		
	return 0




# MISC # ------------------------------------------------------------------------------------------


func disable_yokai() -> void:
	
	for i in range(len(player_team_inst_front)):
		player_team_inst_front[i].disable_tick()
	
	for i in range(len(enemy_team_inst_front)):
		enemy_team_inst_front[i].disable_tick()


func enable_yokai() -> void:
	
	for i in range(len(player_team_inst_front)):
		player_team_inst_front[i].enable_tick()
	
	for i in range(len(enemy_team_inst_front)):
		enemy_team_inst_front[i].enable_tick()


# -------------------------------------------------------------------------------------------------
