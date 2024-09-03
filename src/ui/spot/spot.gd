class_name Spot extends CanvasLayer


const SPEED: int = 150


var input_vector: Vector2 = Vector2.ZERO
var can_start_battle: bool = false
var yokai_arr: Array[Yokai] = [Yokai.new("Jibanyan"), Yokai.new("Jibanyan"), Yokai.new("Jibanyan")]


@onready var Target: Sprite2D = $target


func _ready() -> void:
	get_tree().paused = true
	PhysicsServer2D.set_active(true)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space"):
		Target.frame = 1
		
		if can_start_battle:
			global.on_battle_started.emit(yokai_arr)
			queue_free()	
	else:
		Target.frame = 0
	
	if event.is_action_pressed("shift"):
		get_tree().paused = false
		queue_free()


func set_enemy_arr(enemy_arr: Array[Yokai]) -> void:
	yokai_arr = enemy_arr


func _physics_process(delta: float) -> void:
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")
	
	input_vector = input_vector.normalized() * SPEED * delta
	Target.position += input_vector


func _on_area_2d_area_entered(area: Area2D) -> void:
	can_start_battle = true
