class_name Debug extends CanvasLayer


@onready var enemy_arr: Array[Yokai] = [
	Yokai.new("Zerberker", preload("res://res/yokai/zerberker/zerberker_back.png")), 
	Yokai.new("Zerberker", preload("res://res/yokai/zerberker/zerberker_back.png")), 
	Yokai.new("Jibanyan", preload("res://res/yokai/jibanyan/jibanyan_one.png")),
]


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("space"):
		global._on_battle_start.emit(enemy_arr)
		queue_free()
