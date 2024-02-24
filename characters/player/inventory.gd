extends CanvasLayer


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("shift"):
		
		get_tree().paused = false
		queue_free()
