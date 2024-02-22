extends CharacterBody2D


var input_vec: Vector2 = Vector2.ZERO
var speed: int = 70


func _process(delta: float) -> void:
	
	if Input.is_action_pressed("shift"):
		speed = 120
	else:
		speed = 70
	
	input_vec.x = Input.get_axis("move_left", "move_right")
	input_vec.y = Input.get_axis("move_up", "move_down")
	
	velocity = input_vec.normalized() * speed
	move_and_slide()
