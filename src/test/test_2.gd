extends Node2D

@export var walk_speed: float = 6.0
@export var pause_time: float = 1.0 # Time to pause before choosing new direction

#@onready var anim_tree: AnimationTree = $AnimationTree
#@onready var anim_state = $AnimationTree.get("parameters/playback")
#@onready var ray: RayCast2D = $RayCast2D

const TILE_SIZE: int = 16

enum NPCState { Idle, Turning, Walking }
enum FacingDirection { Left, Right, Up, Down }

var npc_state := NPCState.Idle
var facing_direction := FacingDirection.Down
var initial_position: Vector2 = Vector2.ZERO
var input_direction: Vector2 = Vector2(0, 1)
var is_moving: bool = true
var percent_moved_to_next_tile: float = 0.0
var directions = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)] 
var remaining_pause_time: float = 0.0

func _ready() -> void:
	#anim_tree.active = true
	initial_position = position 
	remaining_pause_time = pause_time + randf() * 0.5  # Add randomness to the pause
	#choose_new_direction() 
	#anim_tree.set("parameters/idle/blend_position", input_direction)
	#anim_tree.set("parameters/walk/blend_position", input_direction)
	#anim_tree.set("parameters/turn/blend_position", input_direction)

func _physics_process(delta: float) -> void:
	if npc_state == NPCState.Turning:
		return  
	
	if is_moving == false:
		remaining_pause_time -= delta
		if remaining_pause_time <= 0:
			move(delta)
		else:
			pass
			#anim_state.travel("idle") 
	elif input_direction != Vector2.ZERO:
		#anim_state.travel("walk")
		move(delta)
	else:
		#anim_state.travel("idle")
		is_moving = false


func choose_new_direction() -> void:
	var available_directions = directions
	available_directions.shuffle()  
	var new_direction = available_directions[0]
	var new_facing_direction = get_facing_direction_from_vector(new_direction)
	print(new_direction)
	print(new_facing_direction)

	if facing_direction != new_facing_direction:
		start_turning(new_facing_direction)  
	else:
		input_direction = new_direction
		#anim_tree.set("parameters/walk/blend_position", input_direction)
		move(0.0)


func get_facing_direction_from_vector(direction: Vector2) -> FacingDirection:
	if direction.x > 0:
		return FacingDirection.Right
	elif direction.x < 0:
		return FacingDirection.Left
	elif direction.y > 0:
		return FacingDirection.Down
	else:
		return FacingDirection.Up


func start_turning(new_facing_direction: FacingDirection) -> void:
	npc_state = NPCState.Turning
	#anim_state.travel("turn")
	facing_direction = new_facing_direction
	#anim_tree.set("parameters/turn/blend_position", input_direction)


func finished_turning() -> void:
	npc_state = NPCState.Idle
	#anim_state.travel("idle") 
	remaining_pause_time = pause_time
	choose_new_direction()


func move(delta: float) -> void:
	#var desired_step: Vector2 = input_direction * TILE_SIZE / 2
	#ray.target_position = desired_step
	#ray.force_raycast_update()
	
	percent_moved_to_next_tile += walk_speed * delta  
	
	if percent_moved_to_next_tile >= 1.0:
		position = initial_position + (input_direction * TILE_SIZE)
		initial_position = position
		percent_moved_to_next_tile = 0.0
		is_moving = false
		remaining_pause_time = pause_time + randf() * 0.5  
	else:
		print("move")
		position = initial_position + (input_direction * TILE_SIZE * percent_moved_to_next_tile)



func handle_collision() -> void:
	npc_state = NPCState.Idle
	remaining_pause_time = pause_time  
	choose_new_direction()


func need_to_turn() -> bool:
	var new_facing_direction
	if input_direction.x < 0:
		new_facing_direction = FacingDirection.Left
	elif input_direction.x > 0:
		new_facing_direction = FacingDirection.Right
	elif input_direction.y < 0:
		new_facing_direction = FacingDirection.Up
	elif input_direction.y > 0:
		new_facing_direction = FacingDirection.Down

	if facing_direction != new_facing_direction:
		facing_direction = new_facing_direction
		return true
	facing_direction = new_facing_direction
	return false
