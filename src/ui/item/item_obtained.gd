class_name ItemObtained extends CanvasLayer


@onready var ItemLabel: RichTextLabel = $Label


func set_item(_item: String):
	_text(_item)


func _text(_item: String) -> void:
	ItemLabel.text = str(_item) + "obtained."


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space"):
		print("tf")
		await get_tree().physics_frame
		get_tree().paused = false
		queue_free()
