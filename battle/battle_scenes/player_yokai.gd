extends Sprite2D


func _ready() -> void:
	
	set_process(false)


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
	#queue_free()
