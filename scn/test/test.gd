extends CharacterBody2D


const SPEED: int = 70

var input_vec: Vector2 = Vector2.ZERO



func _process(delta: float) -> void:
	input_vec.x = Input.get_axis("move_left", "move_right")
	input_vec.y = Input.get_axis("move_up", "move_down")
	
	velocity = input_vec.normalized() * SPEED
	move_and_slide()
	
