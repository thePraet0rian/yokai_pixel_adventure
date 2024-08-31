class_name Chest extends StaticBody2D


@export var _chest_content: String = "RiceBallz"


var _is_enabled: bool = true


func set_chest_content(content: String) -> void:
	pass


func get_chest_content() -> String:
	return _chest_content


func is_enabled() -> bool:
	return _is_enabled
