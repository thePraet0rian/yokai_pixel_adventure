class_name Debug
extends CanvasLayer


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("space"):
		
		global._on_battle_start.emit()
		queue_free()
