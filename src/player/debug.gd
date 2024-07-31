class_name Debug extends CanvasLayer


@onready var enemy_arr: Array[Yokai] = [
 	Yokai.new("na"),
 	Yokai.new("Zerberker"), 
	Yokai.new("na"),
]


func _input(event: InputEvent) -> void:	
	if event.is_action_pressed("space"):
		global.on_battle_started.emit(enemy_arr)
		queue_free()
	if event.is_action_pressed("esc"):
		global.on_test_start.emit()
		queue_free()
