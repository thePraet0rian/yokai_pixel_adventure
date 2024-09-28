extends Node2D


@onready var Insprited: Sprite2D = $Inspirited


func set_targeted(_target: bool = true) -> void:
	pass


func set_insprited() -> void:
	Insprited.visible = true
