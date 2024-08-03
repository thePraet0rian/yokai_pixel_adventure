class_name BattleYokai extends Sprite2D




signal action

enum {
	PLAYER = 0, 
	ENEMY = 1,
}

const DEAD_YOKAI: Texture = preload("res://res/yokai/general/dead_yokai.png")
const DAMAGE_SCENE: PackedScene = preload("res://scn/battle/misc/damage.tscn")
const WALK_SPEED: int = 5
const TILE_SIZE: Vector2 = Vector2(72, 0)

var active: bool = true

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

@onready var AnimPlayer: AnimationPlayer = $anim_player
@onready var TickTimer: Timer = $tick
@onready var Selector: Sprite2D = $enemy_ui/selector
@onready var SoulimateSelector: Sprite2D = $player_ui/soulimate_selector

@onready var PlayerUi: Node2D = $player_ui
@onready var EnemyUi: Node2D = $enemy_ui

@onready var HealthBar: ColorRect = $player_ui/ui/health_bar
@onready var EnemyHealthBar: ColorRect = $enemy_ui/ui/HealthBar

@onready var TargetArrow: Sprite2D = $target_arrow
@onready var SoulMeter: ColorRect = $player_ui/soul_meter/soul

@onready var PlayerAiInstance: PlayerAi
@onready var EnemyAiInstance: EnemyAi




func _ready() -> void:
	set_process(false)
	
	if not YokaiInst.active:
		active = false
		visible = false
		TickTimer.stop()
	else:
		SoulMeter.scale.y = -(YokaiInst.yokai_soul / 1)


func _update_player() -> void:
	texture = YokaiInst.front_sprite
	
func _update_enemy() -> void:
	texture = YokaiInst.front_sprite



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



# TODO: heal yokai
func heal_yokai(health: int) -> void:
	if YokaiInst.active:
		YokaiInst.yokai_hp += health
		var TweenInst: Tween = get_tree().create_tween()
		HealthBar.scale = Vector2((YokaiInst.yokai_hp / YokaiInst.yokai_max_hp), 1)



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
	
	match team:
		0:
			TweenInst.tween_property(HealthBar, "scale", Vector2(float(YokaiInst.yokai_hp) / float(YokaiInst.yokai_max_hp), 1), 0.5)
		1:
			TweenInst.tween_property(EnemyHealthBar, "scale", Vector2(float(YokaiInst.yokai_hp) / float(YokaiInst.yokai_max_hp), 1), 0.5)
	
	_damage(damage_int)
	
	YokaiHelperInstance.update()


func _damage(_damage: int) -> void:
	print("damage")
	randomize()
	var x: int = randi_range(0, 16)
	var y: int = -randi_range(0, 16)
	
	var DamageInstance: Damage = DAMAGE_SCENE.instantiate()
	DamageInstance.position = Vector2(x, y)
	add_child(DamageInstance)
	DamageInstance.set_damage(_damage)


func disable_tick() -> void:
	TickTimer.stop()
	is_ticking = false


func enable_tick() -> void:
	TickTimer.start()
	is_ticking = true


func player_animation() -> void:
	AnimPlayer.play("flash")


func enemy_animation() -> void:
	AnimPlayer.play("flash")


func _update_player_opponents(opponents: Array[BattleYokai]) -> void:
	PlayerAiInstance.set_enemys(opponents)


func _update_enemy_opponents(opponents: Array[BattleYokai]) -> void:
	EnemyAiInstance.set_players(opponents)



# PUBLIC
func set_team(team_str: String) -> void:
	await ready
	
	match team_str:
		"player":	
			team = PLAYER
			PlayerAiInstance = PlayerAi.new()
			PlayerAiInstance.player_animation.connect(player_animation)
			PlayerAiInstance.set_current_yokai(YokaiInst)
			EnemyUi.visible = false
		"enemy":
			team = ENEMY
			EnemyAiInstance = EnemyAi.new()
			EnemyAiInstance.enemy_animation.connect(enemy_animation)
			EnemyAiInstance.set_current_yokai(YokaiInst)
			PlayerUi.visible = false
			
	update_arr[team].call()


func set_target_arrow() -> void:
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
		
		if active:
			SoulimateSelector.frame = 1
		else:
			SoulimateSelector.frame = 0


func update_opponents(opponents: Array[BattleYokai]) -> void:
	match team:
		PLAYER:
			_update_player_opponents(opponents.duplicate())
		ENEMY:
			_update_enemy_opponents(opponents.duplicate())


func attack_animation() -> void:
	if team == PLAYER:
		player_animation()
	else:
		enemy_animation()	
