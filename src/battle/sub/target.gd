extends Node2D


enum STATE {
	ONE = 1, 
	TWO = 2,
}


@onready var Selector: Area2D = $selector
@onready var BattleInstance: Battle = get_parent().get_parent().get_parent().get_parent()

@onready var Buttons: Array[Sprite2D] = [
	$buttons/back_button,
	$buttons/normal_selector,
	$buttons/back_button3,
	$buttons/back_button4,
]


var input_vector: Vector2 = Vector2.ZERO
var speed: int = 150

var index: float = 1
var hovering: bool = false
var yokai: Area2D


func _ready() -> void:
	get_tree().paused = true
	PhysicsServer2D.set_active(true)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shift"):
		pass
	
	if hovering:
		if event.is_action_pressed("space"):
			yokai.get_parent().get_parent().set_target()
			hovering = false
	else:
		if event.is_action_pressed("space"):
			BattleInstance.YokaiHelperInstance.set_selected_yokai(-1)


func _physics_process(delta: float) -> void:
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")
	
	input_vector = input_vector.normalized() * speed * delta
	Selector.position += input_vector


func _on_selector_area_entered(area: Area2D) -> void:
	if "battle_yokai" in area.name:
		if area.get_parent().get_parent().team == 1:
			hovering = true
			yokai = area
