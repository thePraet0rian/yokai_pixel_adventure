class_name BattleYokai extends Sprite2D


signal action


enum {
	PLAYER = 0, 
	ENEMY = 1,
}


const PLAYER_AI: PackedScene = preload("res://scn/battle/battle_yokai/player_ai.tscn")
const ENEMY_AI: PackedScene = preload("res://scn/battle/battle_yokai/enemy_ai.tscn")

const DEAD_YOKAI: Texture = preload("res://res/yokai/general/dead_yokai.png")

const WALK_SPEED: int = 5
const TILE_SIZE: Vector2 = Vector2(72, 0)


var team: int = PLAYER
var update_arr: Array[Callable] = [_update_player, _update_enemy]
var dirty: bool = false

var progress: float = 0.0
var input_direction: Vector2
var last_position: Vector2

var is_loafing: bool = false
var is_ticking: bool = true
var is_targeted: bool = true
var is_dead: bool = false

var yokai_number: int = 0


@onready var YokaiInst: Yokai
@onready var YokaiHelperInstance: BattleYokaiHelper = get_node("..").get_node("..")

@onready var PlayerAiInstance: PlayerAi
@onready var EnemyAiInstance: EnemyAi

@onready var AnimPlayer: AnimationPlayer = $anim_player
@onready var TickTimer: Timer = $tick
@onready var Selector: Sprite2D = $enemy_ui/selector
@onready var SoulimateSelector: Sprite2D = $player_ui/soulimate_selector
@onready var PlayerUi: Node2D = $player_ui
@onready var HealthBar: ColorRect = $player_ui/ui/health_bar
@onready var AiInstance: Node = $ai

@onready var TargetArrow: Sprite2D = $target_arrow


func set_team(team_str: String) -> void:
	await ready
	
	match team_str:
		"player":	
			team = PLAYER
			PlayerAiInstance = PLAYER_AI.instantiate()
			AiInstance.add_child(PlayerAiInstance)
		"enemy":
			team = ENEMY
			EnemyAiInstance = ENEMY_AI.instantiate()
			AiInstance.add_child(EnemyAiInstance)
		
	update_arr[team].call()


func activate_target_arrow() -> void:
	TargetArrow.visible = true
	await get_tree().create_timer(.5).timeout
	TargetArrow.visible = false


func set_target() -> void:
	if team == ENEMY:
		Selector.visible = true
		YokaiHelperInstance.set_selected_yokai(yokai_number)


func set_soulimate(_selected_soul_yokai: int, active: bool) -> void:
	if team == PLAYER: 
		SoulimateSelector.visible = true
		SoulimateSelector.frame = active if 1 else 0


func _update_player() -> void:
	texture = YokaiInst.front_sprite
	PlayerUi.visible = true
	
	
func _update_enemy() -> void:
	texture = YokaiInst.front_sprite


func _ready() -> void:
	set_process(false)
	

func move_direction(direction: Vector2) -> void:
	last_position = position
	input_direction = direction
	set_process(true)


func _process(delta: float) -> void:
	_move(delta) 


func _move(delta: float) -> void:
	progress += delta * WALK_SPEED 
	
	if input_direction != Vector2.ZERO:
		if progress >= 1.0:
			position = last_position + (TILE_SIZE * input_direction)
			progress = 0.0
			set_process(false)
		else:
			position = last_position + (TILE_SIZE * input_direction * progress)


func _on_tick_timer_timeout() -> void:
	if not is_dead:
		if team == 0: PlayerAiInstance.player_tick()
		if team == 1: EnemyAiInstance.enemy_tick()


func health_update(damage_int: int) -> void:	
	YokaiInst.yokai_hp -= damage_int 
	
	if YokaiInst.yokai_hp <= 0:
		texture = DEAD_YOKAI
		is_dead = true
	
	var TweenInst: Tween = create_tween()
	TweenInst.tween_property(HealthBar, "scale", Vector2(float(YokaiInst.yokai_hp) / float(YokaiInst.yokai_max_hp), 1), 0.5)
	
	YokaiHelperInstance.update()


func disable_tick() -> void:
	TickTimer.stop()
	is_ticking = false


func enable_tick() -> void:
	TickTimer.start()
	is_ticking = true

