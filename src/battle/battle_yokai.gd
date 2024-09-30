class_name BattleYokai extends Sprite2D



const DEAD_YOKAI: Texture = preload("res://res/yokai/general/dead_yokai.png")
const DAMAGE_SCENE: PackedScene = preload("res://scn/battle/misc/damage.tscn")
const WALK_SPEED: int = 5
const TILE_SIZE: Vector2 = Vector2(72, 0)

const PLAYER: int = 0
const ENEMY: int = 1


var progress: float = 0.0
var input_direction: Vector2
var last_position: Vector2

var active: bool = true
var team: int
var dirty: bool = false

var is_targeted: bool = true
var is_dead: bool = false
var move_number: int
var yokai_number: int = 0
var YokaiInst: Yokai


@onready var UiOrganizerInstance: UiOrganizer = $UiOrganizer
@onready var PlayerAiInstance: PlayerAi
@onready var EnemyAiInstance: EnemyAi

@onready var DebugUiTickRect: ColorRect = $DebugUi/ColorRect
@onready var HitSoundEffect: AudioStreamPlayer2D = $HitSoundEffect
@onready var AnimPlayer: AnimationPlayer = $AnimPlayer



func set_yokai_number(_yokai_number: int) -> void:
	yokai_number = _yokai_number
	YokaiInst.yokai_number = _yokai_number


func set_team(_team: int) -> void:
	team = _team


func set_opponents(_opponents: Array[BattleYokai]) -> void:
	match team:
		PLAYER:
			PlayerAiInstance.set_opponents(_opponents)
		ENEMY:
			EnemyAiInstance.set_opponents(_opponents)


func set_target(_active: bool = true) -> void:
	UiOrganizerInstance.set_targeted(_active)


func set_selector(_active: bool = true) -> void:
	UiOrganizerInstance.set_selector(_active)


func set_inspirited() -> void:
	UiOrganizerInstance.set_inspirited()
	YokaiInst.inspirited = true


func set_soulimate(_active: bool) -> void:
	if team == PLAYER: 
		UiOrganizerInstance.set_soulimate(_active)


func set_target_arrow() -> void:
	UiOrganizerInstance.set_target()


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


func set_animation(_animation: String = "attack") -> void:
	match _animation:
		"attack":
			if team == PLAYER:
				_player_attack_animation()
			else:
				_enemy_attack_animation()	
		"inspirit":
			_inpspirit_animation()


func set_heal(_health: int) -> void:
	if YokaiInst.yokai_hp + _health <= YokaiInst.yokai_max_hp:
		YokaiInst.yokai_hp += _health
	else:
		YokaiInst.yokai_hp = YokaiInst.yokai_max_hp



func _ready() -> void:
	_setup_yokai() 
	_setup_movement()
	_setup_ui_organizer()


func _setup_yokai() -> void:
	if not YokaiInst.active:
		active = false
		visible = false
	
	match team:
		0:	
			PlayerAiInstance = PlayerAi.new()
			PlayerAiInstance.set_current_yokai(YokaiInst)
			_update_player()
			
		1:
			EnemyAiInstance = EnemyAi.new()
			EnemyAiInstance.set_current_yokai(YokaiInst)
			_update_enemy()


func _setup_movement() -> void:
	set_process(false)


func _setup_ui_organizer() -> void:
	UiOrganizerInstance.set_yokai_instance(YokaiInst)
	UiOrganizerInstance.set_team(team)


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
		UiOrganizerInstance.set_health(health)


func tick() -> void:
	DebugUiTickRect.color = Color8(255, 0, 0)
	await get_tree().create_timer(.2).timeout
	DebugUiTickRect.color = Color8(255, 255, 255)
	
	match team:
		PLAYER when not is_dead:
			PlayerAiInstance.player_tick()
		ENEMY when not is_dead:
			EnemyAiInstance.enemy_tick()


func _soul_update(_soul: float) -> void:
	YokaiInst.set_soul(_soul)
	UiOrganizerInstance.set_soul()


func _death_check() -> void:
	if YokaiInst.yokai_hp <= 0:
		match team:
			0:	
				texture = DEAD_YOKAI
				is_dead = true
				YokaiInst.active = false
				UiOrganizerInstance.set_inspirited(false)
			1:
				is_dead = true
				YokaiInst.active = false
				visible = false


func _update_health_bar() -> void:
	UiOrganizerInstance.update_health_bar()
	
	
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
	
	var TweenOne: Tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
	var TweenTwo: Tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
	
	TweenOne.set_parallel()
	TweenTwo.set_parallel()
	
	TweenOne.tween_property(self, "position", position - Vector2(0, 8), 0.2)
	TweenTwo.tween_property(self, "scale", scale + Vector2(0, 0.5), 0.2)
	await TweenOne.finished
	
	var TweenThree: Tween = create_tween()
	var TweenFour: Tween = create_tween()
	
	TweenThree.tween_property(self, "position", position + Vector2(0, 8), 0.2)
	TweenFour.tween_property(self, "scale", scale - Vector2(0, 0.5), 0.2)
	
	

  
func _enemy_attack_animation() -> void:
	AnimPlayer.play("flash")
	
	var TweenOne: Tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
	var TweenTwo: Tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
	
	TweenOne.set_parallel()
	TweenTwo.set_parallel()
	
	TweenOne.tween_property(self, "position", position - Vector2(0, 8), 0.2)
	TweenTwo.tween_property(self, "scale", scale + Vector2(0, 0.5), 0.2)
	await TweenOne.finished
	
	var TweenThree: Tween = create_tween()
	var TweenFour: Tween = create_tween()
	
	TweenThree.tween_property(self, "position", position + Vector2(0, 8), 0.2)
	TweenFour.tween_property(self, "scale", scale - Vector2(0, 0.5), 0.2)


func _inpspirit_animation() -> void:
	AnimPlayer.play("flash2")
	#InspiritEffect.visible = true
	#await get_tree().create_timer(.25).timeout
	#InspiritEffect.visible = false
