class_name BattleYokai extends Sprite2D


signal action

enum {PLAYER = 0, ENEMY = 1}

const walk_speed: int = 5
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

var yokai_number: int = 0

@onready var YokaiInst: Yokai
@onready var parent: YokaiHelper = get_node("..").get_node("..")
@onready var ui: Sprite2D = $ui
@onready var anim_player: AnimationPlayer = $anim_player
@onready var tick_timer: Timer = $tick
@onready var damage: Sprite2D = $damage
@onready var selector: Sprite2D = $selector
@onready var SoulimateSelector: Sprite2D = $soulimate_selector


func set_target() -> void:
	
	if team == ENEMY:
		selector.visible = true
		parent.set_selected_yokai(yokai_number)


func set_soulimate(selected_soul_yokai: int, active: bool) -> void:
	
	if team == PLAYER: 
		SoulimateSelector.visible = true
		
		if active:			
			SoulimateSelector.frame = 1
	

func update(team_str: String) -> void:
	if team_str == "player":
		team = PLAYER
	elif team_str == "enemy":
		team = ENEMY
	
	update_arr[team].call()


func _update_player() -> void:
	texture = YokaiInst.front_sprite
	
	
func _update_enemy() -> void:
	texture = YokaiInst.front_sprite
	await ready
	ui.visible = false


func _ready() -> void:
	set_process(false)
	

func move_direction(direction: Vector2) -> void:
	last_position = position
	input_direction = direction
	set_process(true)


func _process(delta: float) -> void:
	_move(delta) 


func _move(delta: float) -> void:
	progress += delta * walk_speed 
	
	if input_direction != Vector2.ZERO:
		if progress >= 1.0:
			position = last_position + (TILE_SIZE * input_direction)
			progress = 0.0
			set_process(false)
		else:
			position = last_position + (TILE_SIZE * input_direction * progress)


func remove() -> void:
	await get_tree().create_timer(.5).timeout
	queue_free()

func _on_tick_timer_timeout() -> void:
	
	print("tick")
	
	if team == 0:
		_player_tick()
	if team == 1:
		_enemy_tick()


func _player_tick() -> void: 
	
	if _behavoir_barrier():
		_player_behavoir()


func _enemy_tick() -> void:
	if _behavoir_barrier():
		pass	


func _behavoir_barrier() -> bool: 
	randomize()
	var random_float: float = randf()
	
	if random_float < 0.2:
		return true
	return false


func _player_behavoir() -> void:
	if not loaf():
		match YokaiInst.yokai_behavior:
			0:
				_player_grouchy_behavoir()


func loaf() -> bool:
	if is_loafing:
		randomize()
		var random_float: float = randf()
		
		if random_float < 0.5:
			is_loafing = false
			return false
		else:
			return true
	else:
		randomize()
		var random_float: float = randf()
		
		if random_float < YokaiInst.loafing_bound():
			is_loafing = false
			return false
		else:
			is_loafing = true
			return true


func _player_grouchy_behavoir() -> void:
	
	#if parent.pick_alive() == -1:
		#return
	anim_player.play("flash")
	global.on_yokai_action.emit(0, 0, "attack")


func health_update(_damage: int) -> void:
	
	damage.visible = true
	
	YokaiInst.yokai_hp -= _damage
	
	if YokaiInst.yokai_hp <= 0:
		visible = false


func disable_tick() -> void:

	tick_timer.stop()
	is_ticking = false

func enable_tick() -> void:

	tick_timer.start()
	is_ticking = true

