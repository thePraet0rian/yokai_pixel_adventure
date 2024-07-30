class_name Debug extends CanvasLayer


@onready var enemy_arr: Array[Yokai] = [
 	null, 
	Yokai.new("Zerberker", preload("res://res/yokai/zerberker/zerberker_back.png"), load("res://res/yokai/cadin/cadin_medall.png")), 
	null,
]


func _input(event: InputEvent) -> void:	
	if event.is_action_pressed("space"):
		global.on_battle_started.emit(enemy_arr)
		queue_free()
	if event.is_action_pressed("esc"):
		global.on_test_start.emit()
		queue_free()
