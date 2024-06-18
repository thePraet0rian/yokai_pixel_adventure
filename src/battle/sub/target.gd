extends Node2D


enum STATE {ONE = 1, TWO = 2}

var index: int = 1
var current_state: STATE = STATE.ONE
var input_vector: Vector2 = Vector2.ZERO

@onready var Buttons: Array[Sprite2D] = [
	$buttons/back_button,
	$buttons/normal_selector,
	$buttons/back_button3,
	$buttons/back_button4,
]

@onready var selector: Area2D = $selector


func _ready() -> void:
	
	await selector.area_entered
	print("fuck")


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("shift"):
		pass


func _physics_process(_delta: float) -> void:
	
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")
	
	input_vector = input_vector.normalized()
	selector.position += input_vector


func _on_selector_area_entered(area: Area2D) -> void:
	
	if "battle_yokai" in area.name:
		area.get_parent().set_target()
