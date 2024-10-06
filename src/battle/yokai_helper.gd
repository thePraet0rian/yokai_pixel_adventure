class_name YokaiHelper extends Node



const BATTLE_YOKAI_SCENE: PackedScene = preload("res://scn/battle/battle_yokai.tscn")
const MOVE_DIRECTIONS: Array[Vector2] = [Vector2.LEFT, Vector2.RIGHT]


var player_yokai_arr: Array[Yokai]
var enemy_yokai_arr: Array[Yokai]

static var player_team_inst_front: Array[BattleYokai]
static var player_team_inst_back: Array[BattleYokai]

static var enemy_team_inst_front: Array[BattleYokai]

var input_direction: Vector2 = Vector2.ZERO
var is_moving: bool = false
var yokai_finished_moving: bool = true

var index: int = 0
var attack_order: Array[BattleYokai]


@onready var YokaiHelperAnimationPlayer: AnimationPlayer = $YokaiHelperAnimationPlayer

@onready var Players: Node2D = $Players
@onready var Enemies: Node2D = $Enemies
@onready var BattleInstance: Battle = get_parent()
@onready var TickTimer: Timer = $TickTimer





func set_player_yokai_arr(_arr: Array) -> void:
	player_yokai_arr = _arr


func set_enemy_yokai_arr(_arr: Array) -> void:
	enemy_yokai_arr = _arr


func setup() -> void:
	_setup_yokai()


func set_move(_direction: int) -> void:
	_move_yokai(_direction)


#func set_selected_yokai(_yokai_number: int) -> void:
	#for i in range(3):
		#if _yokai_number == i:
			#enemy_team_inst_front[i].set_selector()

#WARNING: TO BE DELETED
func set_speed(_speed: float) -> void:
	pass


func set_heal(health: int) -> void:
	for i in range(len(player_team_inst_front)):
		player_team_inst_front[i].heal_yokai(health)


func set_soulimate_selected_yokai(_yokai: int) -> void:
	for i in player_team_inst_front.size():
		if i == _yokai:
			player_team_inst_front[i].set_soulimate(true)
		else:
			player_team_inst_front[i].set_soulimate(false)


static func get_player_back_arr() -> Array[BattleYokai]:
	return player_team_inst_back



func _start_battle() -> void:
	YokaiHelperAnimationPlayer.play("show_player_yokai")
	await YokaiHelperAnimationPlayer.animation_finished
	TickTimer.start()


func _ready() -> void:
	_connect_signals()


func _setup_yokai() -> void:
	_setup_players()
	_setup_enemies()
	_update_yokais()
	_sort_attack_order()


func _setup_players() -> void:
	for i in range(3):
		var BattleYokaiInst: BattleYokai = BATTLE_YOKAI_SCENE.instantiate()
			
		BattleYokaiInst.position = Vector2(48, 91) + Vector2(72, 0) * i
		BattleYokaiInst.YokaiInst = player_yokai_arr[i]
		BattleYokaiInst.set_team(0)
		BattleYokaiInst.set_yokai_number(i)
			
		player_team_inst_front.append(BattleYokaiInst)
		Players.add_child(BattleYokaiInst)
	
	for i in range(3, 6):	
		var BattleYokaiInst: BattleYokai = BATTLE_YOKAI_SCENE.instantiate()
		
		BattleYokaiInst.position = Vector2(-200, -200)
		BattleYokaiInst.YokaiInst = player_yokai_arr[i]
		BattleYokaiInst.set_team(0)
		BattleYokaiInst.set_yokai_number(i)
			
		player_team_inst_back.append(BattleYokaiInst)
		Players.add_child(BattleYokaiInst)


func _setup_enemies() -> void:
	for i in range(3):
		if enemy_yokai_arr[i] != null:
			var BattleYokaiInst: Sprite2D = BATTLE_YOKAI_SCENE.instantiate()
			
			BattleYokaiInst.position = Vector2(48, 40) + Vector2(72, 0) * i
			BattleYokaiInst.YokaiInst = enemy_yokai_arr[i]
			BattleYokaiInst.set_team(1)
			BattleYokaiInst.set_yokai_number(i)

			enemy_team_inst_front.append(BattleYokaiInst)
			Enemies.add_child(BattleYokaiInst)


func _update_yokais() -> void:
	for i in range(len(player_team_inst_front)):
		player_team_inst_front[i].set_opponents(enemy_team_inst_front)
	for i in range(len(enemy_team_inst_front)):
		enemy_team_inst_front[i].set_opponents(player_team_inst_front)


func _sort_attack_order() -> void:
	attack_order.append_array(player_team_inst_front)
	attack_order.append_array(enemy_team_inst_front)


func _connect_signals() -> void:
	global.on_yokai_action.connect(_on_yokai_action)
	GlobalBattle.start_battle.connect(_start_battle)
	GlobalBattle.update.connect(update)


func _on_yokai_action(_action: String, _team: int, _yokai_one: int = 0, _yokai_two: int = 0, _args: Array = []) -> void:
	match _action: 
		"attack":
			_attack(_team, _yokai_one, _yokai_two, _args)
		"inspirit":
			_inspirit(_team, _yokai_one, _yokai_two)
		"heal":
			_heal(_team, _yokai_one)
		"give":
			_give()
		"target":
			_target(_yokai_one)


func _attack(team: int, acting_yokai: int, yokai: int, args: Array) -> void:
	print("acting_yokai: " + str(acting_yokai))
	
	match team:
		0:
			player_team_inst_front[acting_yokai].set_animation("attack")
			await get_tree().create_timer(0.5).timeout
			enemy_team_inst_front[yokai].set_target_arrow()
			enemy_team_inst_front[yokai].set_damage(5 + 10 * args[0])
		1:
			enemy_team_inst_front[acting_yokai].set_animation("attack")
			await get_tree().create_timer(0.5).timeout
			player_team_inst_front[yokai].set_target_arrow()
			player_team_inst_front[yokai].set_damage(5 + 10 * args[0])
	
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
	match team:
		0:
			player_team_inst_front[yokai].set_heal(100)
		1:
			pass


func _give() -> void:
	pass


func _target(_yokai: int) -> void:
	for i in enemy_team_inst_front.size():
		if i == _yokai:
			enemy_team_inst_front[i].set_selector(true)
		else:
			enemy_team_inst_front[i].set_selector(false)



func _move_yokai(dir: int) -> void:
	yokai_finished_moving = false
	
	if dir == 0:
		_move_left()
	elif dir == 1:
		_move_right()
	
	for i in range(len(player_team_inst_front)):
		player_team_inst_front[i].set_move_direction(MOVE_DIRECTIONS[dir], i)
	
	if dir == 0:
		player_team_inst_front.remove_at(0)
		player_team_inst_back.remove_at(3)
	elif dir == 1:
		player_team_inst_front.remove_at(3)
		player_team_inst_back.remove_at(0)
	
	#BattleInstance.update_medalls()
	_update_yokais()


func _move_left() -> void:
	var new_yokai: Node2D = player_team_inst_back[2]
	
	new_yokai.position = Vector2(264, 91)
	new_yokai.visible = true

	player_team_inst_front.append(new_yokai)
	player_team_inst_back.insert(0, player_team_inst_front[0])

	new_yokai.set_team(0)
	yokai_finished_moving = true


func _move_right() -> void:
	var new_yokai: Node2D = player_team_inst_back[0]
	
	new_yokai.position = Vector2(-24, 91)
	new_yokai.visible = true

	player_team_inst_front.insert(0, new_yokai)
	player_team_inst_back.append(player_team_inst_front[3])

	new_yokai.set_team(0)
	yokai_finished_moving = true


func start_soulimate(_yokai: int) -> void:
	for i in range(3):
		enemy_team_inst_front[i].set_damage(1000)


func disable_soulimate_ui() -> void:
	for i in range(len(player_team_inst_front)):
		player_team_inst_front[i].set_soulimate(false)

# TODO: IMPLEMENT SOULIMATE WARNING: DO NOT READ THIS SHIT
func _selected_yokai(yokai_number: int) -> void:		
	for i in range(3):
		if i == yokai_number:
			player_team_inst_front[i].set_soulimate(true)
		else: 
			player_team_inst_front[i].set_soulimate(false)

func update() -> void:
	BattleInstance.update_battle_conditions()


func _on_tick_timer_timeout() -> void:
	attack_order[index].tick()
	index = (index + 1) % 6
