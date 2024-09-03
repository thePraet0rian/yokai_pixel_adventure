class_name BattleYokai extends Sprite2D


const PLAYER: int = 0
const ENEMY: int = 1

const DEAD_YOKAI: Texture = preload("res://res/yokai/general/dead_yokai.png")
const DAMAGE_SCENE: PackedScene = preload("res://scn/battle/misc/damage.tscn")
const WALK_SPEED: int = 5
const TILE_SIZE: Vector2 = Vector2(72, 0)


var active: bool = true

var team: int
var dirty: bool = false

var progress: float = 0.0
var input_direction: Vector2
var last_position: Vector2

var is_ticking: bool = true
var is_targeted: bool = true
var is_dead: bool = false

var move_number: int
var yokai_number: int = 0

var YokaiInst: Yokai


#TBD PARENT REFERENCES SHOULD BE REMOVED
@onready var YokaiHelperInstance: BattleYokaiHelper = get_node("..").get_node("..")

@onready var AnimPlayer: AnimationPlayer = $AnimPlayer
@onready var TickTimer: Timer = $TickTimer

@onready var SoulimateSelector: Sprite2D = $player_ui/soulimate_selector
@onready var Selector: Sprite2D = $enemy_ui/selector

@onready var PlayerUi: Node2D = $player_ui
@onready var EnemyUi: Node2D = $enemy_ui

@onready var HealthBar: ColorRect = $player_ui/ui/health_bar
@onready var EnemyHealthBar: ColorRect = $enemy_ui/ui/HealthBar

@onready var TargetArrow: Sprite2D = $TargetArrow
@onready var SoulMeter: ColorRect = $player_ui/soul_meter/soul

@onready var PlayerAiInstance: PlayerAi
@onready var EnemyAiInstance: EnemyAi

@onready var HitSoundEffect: AudioStreamPlayer2D = $HitSoundEffect
@onready var InspiritedSprite: Sprite2D = $Inspirited


@onready var DebugUiTickRect: ColorRect = $debug_ui/ColorRect


func _ready() -> void:
	set_process(false)
	
	if not YokaiInst.active:
		active = false
		visible = false
		TickTimer.stop()
	else:
		SoulMeter.scale.y = -(YokaiInst.yokai_soul / 1)
		HealthBar.scale.x = (float(YokaiInst.yokai_hp) / float(YokaiInst.yokai_max_hp))


func set_tick(ticking: bool) -> void:
	is_ticking = ticking
	
	if ticking:
		TickTimer.start()
	else:
		TickTimer.stop()


func set_team(team_str: String) -> void:
	await ready
	
	match team_str:
		"player":	
			team = PLAYER
			PlayerAiInstance = PlayerAi.new()
			PlayerAiInstance.set_current_yokai(YokaiInst)
			EnemyUi.visible = false
			
			_update_player()
		"enemy":
			team = ENEMY
			EnemyAiInstance = EnemyAi.new()
			EnemyAiInstance.set_current_yokai(YokaiInst)
			PlayerUi.visible = false
			
			_update_enemy()


func set_opponents(opponents: Array[BattleYokai]) -> void:
	match team:
		PLAYER:
			PlayerAiInstance.set_enemys(opponents)	
		ENEMY:
			EnemyAiInstance.set_players(opponents)


func set_target() -> void:
	if team == ENEMY:
		Selector.visible = true
		YokaiHelperInstance.set_selected_yokai(yokai_number)
		YokaiInst.targeted = true


func set_inspirited() -> void:
	InspiritedSprite.visible = true
	YokaiInst.inspirited = true


func set_soulimate(_selected_soul_yokai: int, _active: bool) -> void:
	if team == PLAYER: 
		SoulimateSelector.visible = true
		
		if _active:
			SoulimateSelector.frame = 1
		else:
			SoulimateSelector.frame = 0


func set_target_arrow() -> void:
	TargetArrow.visible = true
	await get_tree().create_timer(.5).timeout
	TargetArrow.visible = false


func set_damage(_damage_int: int) -> void:
	YokaiInst.yokai_hp -= _damage_int
	
	_death_check()
	_damage(_damage_int)
	_update_health_bar()


func set_move_direction(direction: Vector2, number: int) -> void:
	last_position = position
	input_direction = direction
	set_process(true)
	move_number = number


# TBD: MUTLIPLE DIFFERENT ANIMATIONS
func set_animation(_animation: String = "attack") -> void:
	match _animation:
		"attack":
			if team == PLAYER:
				_player_attack_animation()
			else:
				_enemy_attack_animation()	
		"inspirit":
			_inpspirit_animation()


func set_speed(_speed: float) -> void:
	TickTimer.wait_time = TickTimer.wait_time * _speed


func set_heal(_health: int) -> void:
	print(YokaiInst.yokai_hp)
	if YokaiInst.yokai_hp + _health <= YokaiInst.yokai_max_hp:
		YokaiInst.yokai_hp += _health
	else:
		YokaiInst.yokai_hp = YokaiInst.yokai_max_hp
	print(YokaiInst.yokai_hp)
	HealthBar.scale.x = (float(YokaiInst.yokai_hp) / float(YokaiInst.yokai_max_hp))


func _update_player() -> void:
	texture = YokaiInst.front_sprite
	
func _update_enemy() -> void:
	texture = YokaiInst.front_sprite


func _process(delta: float) -> void:
	_move(delta) 

func _move(delta: float) -> void:
	progress += delta * WALK_SPEED 
	
	if input_direction != Vector2.ZERO:
		if progress >= 1.0:
			position = last_position + (TILE_SIZE * input_direction)
			progress = 0.0
			set_process(false)
			if input_direction == Vector2.LEFT:
				if move_number == 0:
					visible = false
			else:
				if move_number == 3:
					visible = false
			global.on_yokai_action_finished.emit()
		else:
			position = last_position + (TILE_SIZE * input_direction * progress)


# TODO: HEAL YOKAI IMPLEMENT
func heal_yokai(health: int) -> void:
	if YokaiInst.active:
		YokaiInst.yokai_hp += health
		#var TweenInst: Tween = get_tree().create_tween()
		HealthBar.scale = Vector2((float(YokaiInst.yokai_hp) / float(YokaiInst.yokai_max_hp)), 1)


func _on_tick_timer_timeout() -> void:
	if not is_dead:
		if team == 0: 
			PlayerAiInstance.player_tick()
			_soul_update(0.25)
		if team == 1: 
			EnemyAiInstance.enemy_tick()
	
	DebugUiTickRect.color = Color8(255, 0, 0)
	await get_tree().create_timer(.2).timeout
	DebugUiTickRect.color = Color8(255, 255, 255)


func _soul_update(soul: float) -> void:
	YokaiInst.set_soul(soul)
	SoulMeter.scale.y = -(YokaiInst.yokai_soul / 1.0)


func _death_check() -> void:
	if YokaiInst.yokai_hp <= 0:
		texture = DEAD_YOKAI
		is_dead = true
		YokaiInst.active = false
		TickTimer.stop()
		InspiritedSprite.visible = false  


func _update_health_bar() -> void:
	var TweenInst: Tween = create_tween()
	var updated_hp: float = float(YokaiInst.yokai_hp) / float(YokaiInst.yokai_max_hp)
	
	match team:
		0:
			TweenInst.tween_property(HealthBar, "scale", Vector2(updated_hp, 1), 0.5)
		1:
			TweenInst.tween_property(EnemyHealthBar, "scale", Vector2(updated_hp, 1), 0.5)
	
	await TweenInst.finished
	YokaiHelperInstance.update()
	
	
func _damage(_damage_int: int) -> void:
	randomize()
	var x: int = randi_range(0, 16)
	var y: int = -randi_range(0, 16)
	
	var DamageInstance: Damage = DAMAGE_SCENE.instantiate()
	DamageInstance.position = Vector2(x, y)
	add_child(DamageInstance)
	DamageInstance.set_damage(_damage_int)
	HitSoundEffect.play()


func _player_attack_animation() -> void:
	AnimPlayer.play("flash")

func _enemy_attack_animation() -> void:
	AnimPlayer.play("flash")

func _inpspirit_animation() -> void:
	AnimPlayer.play("flash2")
