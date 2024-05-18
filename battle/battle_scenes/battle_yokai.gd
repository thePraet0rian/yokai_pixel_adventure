class_name BattleYokai extends Sprite2D


#region SETUP #################################################################


signal action()

enum {PLAYER = 0, ENEMY = 1}

@onready var Yokai: global.Yokai
@onready var parent: Battle = get_node("..").get_node("..")

var team: int = PLAYER
var update_arr: Array = [_update_player, _update_enemy]
var dirty: bool = false


func _ready() -> void:
	
	set_process(false)


func update(team_str: String) -> void:
	
	if team_str == "player":
		team = PLAYER
	elif team_str == "enemy":
		team = ENEMY
	
	update_arr[team].call()
	
	
func _update_player() -> void:
	texture = Yokai.front_sprite
	

func _update_enemy() -> void:
	texture = Yokai.front_sprite


#endregion 
#region MOVEMENT ##############################################################

var progress: float = 0.0
var input_direction: Vector2
var last_position: Vector2

const walk_speed: int = 5
const TILE_SIZE: Vector2 = Vector2(72, 0)


func move_direction(direction: Vector2) -> void:
	
	last_position = position
	input_direction = direction
	set_process(true)


func _process(delta: float) -> void:
	
	move(delta) 


func move(delta: float) -> void:
	
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

#endregion
#region PLAYER BEHAVOIR #######################################################

var is_loafing: bool = false


func player_tick() -> void:
	
	randomize()
	var random_float: float = randf()
	
	print_rich("[color=green]BattleYokai Tick[/color]")
	if random_float < 0.2:
		player_behavoir()


func player_behavoir() -> void:
	
	if not loaf():
		match Yokai.yokai_behavior:
			
			0:
				player_grouchy_behavoir()


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
		
		if random_float < Yokai.loafing_bound():
			is_loafing = false
			return false
		else:
			is_loafing = true
			return true


@onready var anim_player: AnimationPlayer = $AnimationPlayer


func player_grouchy_behavoir() -> void:
	
	if parent.pick_alive() == -1:
		return

	print_rich("[color=red]player_attack[/color]")
	anim_player.play("flash")
	global._on_yokai_action.emit(0, 0, "attack")


#endregion
#region ENEMEY BEHAVOIR #######################################################

func enemy_tick() -> void:
	randomize()
	var random_float: float = randf()
	
	if random_float < 0.2:
		pass

#endregion


func health_update() -> void:
	
	if Yokai.yokai_hp <= 0:
		visible = false
