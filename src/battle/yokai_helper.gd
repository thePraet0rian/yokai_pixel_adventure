class_name BattleYokaiHelper extends Node


const PLAYER_TEAM: int = 0
const ENEMY_TEAM: int = 1

const BATTLE_YOKAI_SCENE: PackedScene = preload("res://scn/battle/battle_yokai.tscn")
const DIRECTION_MOVE: PackedVector2Array = [Vector2.LEFT, Vector2.RIGHT]
const FRONT_YOKAI_ARRAY_LENGHT: int = 3


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
@onready var BattleInstance: Battle = get_parent()

@onready var DebugLabel: Label = $debuglabel 



func setup_yokai() -> void:
	_setup_players()
	_setup_enemies()
	_update_yokais()


func _update_yokais() -> void:
	for i in range(len(player_team_inst_front)):
		player_team_inst_front[i].set_opponents(enemy_team_inst_front)
	for i in range(len(enemy_team_inst_front)):
		enemy_team_inst_front[i].set_opponents(player_team_inst_front)


func move_yokai(dir: int) -> void:
	yokai_finished_moving = false
	
	if dir == 0:
		_move_left()
	elif dir == 1:
		_move_right()
	
	for i in range(len(player_team_inst_front)):
		player_team_inst_front[i].set_move_direction(DIRECTION_MOVE[dir], i)
	
	if dir == 0:
		player_team_inst_front.remove_at(0)
		player_team_inst_back.remove_at(3)
	elif dir == 1:
		player_team_inst_front.remove_at(3)
		player_team_inst_back.remove_at(0)
	
	BattleInstance.update_medalls()
	_update_yokais()
	


func on_yokai_action(action: String, team: int, acting_yokai: int, yokai: int, attack_type: int = 0) -> void:
	match action: 
		"attack":
			_attack(team, yokai, acting_yokai, attack_type)
		"inspirit":
			_inspirit(team, yokai, acting_yokai)
		"heal":
			_heal(team, acting_yokai)
		"give":
			pass


func _attack(team: int, yokai: int, acting_yokai: int, attack_type: int) -> void:
	match team:
		0:
			player_team_inst_front[acting_yokai].set_animation("attack")
			await get_tree().create_timer(0.5).timeout
			enemy_team_inst_front[yokai].set_target_arrow()
			enemy_team_inst_front[yokai].set_damage(5 + 10 * attack_type)
		1:
			enemy_team_inst_front[acting_yokai].set_animation("attack")
			await get_tree().create_timer(0.5).timeout
			player_team_inst_front[yokai].set_target_arrow()
			player_team_inst_front[yokai].set_damage(5 + 10 * attack_type)
	
	BattleInstance.update_battle_conditions()
	global.on_yokai_action_finished.emit()


func _inspirit(team: int, yokai: int, acting_yokai: int) -> void:
	match team:
		0:
			player_team_inst_front[acting_yokai].set_animation("inspirit")
			await get_tree().create_timer(0.5).timeout
			enemy_team_inst_front[yokai].set_inspirited()
		1:
			enemy_team_inst_front[acting_yokai].set_animation("inspirit")
			await get_tree().create_timer(0.5).timeout  
			player_team_inst_front[yokai].set_inspirited()
	
	global.on_yokai_action_finished.emit()


func _heal(team: int, yokai: int) -> void:
	print(yokai)
	match team:
		0:
			player_team_inst_front[yokai].set_heal(100)
		1:
			pass


func update() -> void:
	BattleInstance.update_battle_conditions()


# --- PRIVATE --- #


func _ready() -> void:	
	global.on_yokai_action.connect(on_yokai_action)


func _setup_players() -> void:
	for i in range(FRONT_YOKAI_ARRAY_LENGHT):
		var BattleYokaiInst: BattleYokai = BATTLE_YOKAI_SCENE.instantiate()
			
		BattleYokaiInst.position = Vector2(48, 91) + Vector2(72, 0) * i
		BattleYokaiInst.YokaiInst = player_yokai_arr[i]
		BattleYokaiInst.set_team("player")
		BattleYokaiInst.YokaiInst.yokai_number = i
			
		player_team_inst_front.append(BattleYokaiInst)
		Players.add_child(BattleYokaiInst)
	
	for i in range(3, 6):	
		var BattleYokaiInst: BattleYokai = BATTLE_YOKAI_SCENE.instantiate()
		
		BattleYokaiInst.position = Vector2(-200, -200)
		BattleYokaiInst.YokaiInst = player_yokai_arr[i]
		BattleYokaiInst.set_team("player")
			
		player_team_inst_back.append(BattleYokaiInst)
		Players.add_child(BattleYokaiInst)
			
		BattleYokaiInst.set_tick(false)



func _setup_enemies() -> void:
	for i in range(FRONT_YOKAI_ARRAY_LENGHT):
		if enemy_yokai_arr[i] != null:
			
			var BattleYokaiInst: Sprite2D = BATTLE_YOKAI_SCENE.instantiate()
			
			BattleYokaiInst.position = Vector2(48, 40) + Vector2(72, 0) * i
			BattleYokaiInst.YokaiInst = enemy_yokai_arr[i]
			BattleYokaiInst.yokai_number = i
			BattleYokaiInst.set_team("enemy")
			BattleYokaiInst.YokaiInst.yokai_number = i

			enemy_team_inst_front.append(BattleYokaiInst)
			Enemies.add_child(BattleYokaiInst)


# TODO: IMPLEMENT BIG CUSTOM BOSS YOKAI
func _setup_boss() -> void:
	pass


func _move_left() -> void:
	var new_yokai: Node2D = player_team_inst_back[2]
	
	new_yokai.position = Vector2(264, 91)
	new_yokai.set_tick(true)
	new_yokai.visible = true

	player_team_inst_front.append(new_yokai)
	player_team_inst_back.insert(0, player_team_inst_front[0])
	player_team_inst_back[0].set_tick(false)

	new_yokai.set_team("player")
	yokai_finished_moving = true


func _move_right() -> void:
	var new_yokai: Node2D = player_team_inst_back[0]
	
	new_yokai.position = Vector2(-24, 91)
	new_yokai.set_tick(true)
	new_yokai.visible = true

	player_team_inst_front.insert(0, new_yokai)
	player_team_inst_back.append(player_team_inst_front[3])
	player_team_inst_back[3].set_tick(false)

	new_yokai.set_team("player")
	yokai_finished_moving = true


# --- PUBLIC --- #



func set_player_yokai_arr(arr: Array) -> void:
	player_yokai_arr = arr

func set_enemy_yokai_arr(arr: Array) -> void:
	enemy_yokai_arr = arr



# TODO: SET SPEED
func set_speed(_speed: float) -> void:
	for i in range(len(player_team_inst_front)):
		player_team_inst_front[i].set_speed(_speed)
	
	for i in range(len(enemy_team_inst_front)):
		enemy_team_inst_front[i].set_speed(_speed)



func set_selected_yokai(yokai_number: int) -> void:	
	for i in range(FRONT_YOKAI_ARRAY_LENGHT):
		if yokai_number != i:
			enemy_team_inst_front[i].Selector.visible = false



# TODO: IMPLEMENT SOULIMATE WARNING: DO NOT READ THIS SHIT
func set_soulimate_selected_yokai(yokai_number: int) -> void:		
	for i in range(FRONT_YOKAI_ARRAY_LENGHT):
		if i == yokai_number:
			player_team_inst_front[i].set_soulimate(yokai_number, true)
		else: 
			player_team_inst_front[i].set_soulimate(yokai_number, false)

func start_soulimate(_yokai: int) -> void:
	for i in range(FRONT_YOKAI_ARRAY_LENGHT):
		enemy_team_inst_front[i].set_damage(1000)

func disable_soulimate_ui() -> void:	
	for i in range(len(player_team_inst_front)):
		player_team_inst_front[i].SoulimateSelector.visible = false



func set_yokai_tick(tick: bool) -> void:
	if tick:
		for i in range(len(player_team_inst_front)):
			player_team_inst_front[i].set_tick(true)
	
		for i in range(len(enemy_team_inst_front)):
			enemy_team_inst_front[i].set_tick(true)
	else:
		for i in range(len(player_team_inst_front)):
			player_team_inst_front[i].set_tick(false)
	
		for i in range(len(enemy_team_inst_front)):
			enemy_team_inst_front[i].set_tick(false)
	

func get_player_back() -> Array[BattleYokai]:
	return player_team_inst_back


func set_heal(health: int) -> void:
	for i in range(len(player_team_inst_front)):
		player_team_inst_front[i].heal_yokai(health)


func _on_timer_timeout() -> void:
	DebugLabel.text = player_team_inst_front[0].YokaiInst.yokai_name + "," + player_team_inst_front[1].YokaiInst.yokai_name + "," + player_team_inst_front[2].YokaiInst.yokai_name
