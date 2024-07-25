extends Node2D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space"):
		_end()


func _end() -> void:
	global.on_battle_ended.emit()
	queue_free()
