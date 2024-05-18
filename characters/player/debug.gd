class_name Debug extends CanvasLayer


@onready var enemy_arr: Array[global.Yokai] = [
	global.Yokai.new("Zerberker", preload("res://yokai/zerberker/zerberker_back.png")), 
	global.Yokai.new("Zerberker", preload("res://yokai/zerberker/zerberker_back.png")), 
	global.Yokai.new("Zerberker", preload("res://yokai/zerberker/zerberker_back.png")),
]


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("space"):
		
		global._on_battle_start.emit(enemy_arr)
		queue_free()
