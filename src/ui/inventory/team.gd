class_name Team extends Node2D


signal team_close


@onready var BackButton: Sprite2D = $buttons/Sprite2D
@onready var SpaceButton: Sprite2D = $buttons/Sprite2D2


# Private Methods # -------------------------------------------------------------------------------


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("space"):
		SpaceButton.frame = 1
	
	if event.is_action_pressed("shift"):
		_end()


func _end() -> void:
	
	await get_tree().physics_frame
	BackButton.frame = 1
	team_close.emit(0)
	visible = false
