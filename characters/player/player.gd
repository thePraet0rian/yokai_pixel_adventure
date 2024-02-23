class_name player
extends CharacterBody2D

var input_vec: Vector2 = Vector2.ZERO
var speed: int = 70


const debug_scn: PackedScene = preload("res://characters/player/debug.tscn")


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("esc"): 
		
		get_parent().add_child(debug_scn.instantiate())
		get_tree().paused = false


func _process(delta: float) -> void:
	
	if Input.is_action_pressed("shift"):
		speed = 120
	else:
		speed = 70
	
	input_vec.x = Input.get_axis("move_left", "move_right")
	input_vec.y = Input.get_axis("move_up", "move_down")
	
	velocity = input_vec.normalized() * speed
	move_and_slide()
