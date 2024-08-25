extends CanvasLayer


var quest_name: String


func set_quest_name(_quest_name: String) -> void:
	quest_name = _quest_name



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space"):
		GlobalQuests.set_quest_activity(quest_name)
		get_tree().paused = false
		queue_free()
