class_name debug
extends CanvasLayer


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("space"):
		
		global.battle_start.emit()
		print("start battle")
		queue_free()
