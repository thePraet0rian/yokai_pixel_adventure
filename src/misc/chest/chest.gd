class_name Chest extends StaticBody2D


@export var _chest_content: String = "RiceBallz"


var _is_enabled: bool = true


@onready var ChestSprite: Sprite2D = $ChestSprite


func set_chest_content(content: String) -> void:
	pass


func set_chest_used(use: bool) -> void:
	if use:
		_is_enabled = false
		ChestSprite.frame = 1


func get_chest_content() -> String:
	return _chest_content


func is_enabled() -> bool:
	return _is_enabled
