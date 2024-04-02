extends Node2D


const room_scn: PackedScene = preload("res://main.tscn")


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("space"):
		get_parent().add_child(room_scn.instantiate())
		global._on_load.emit(0)
		queue_free()
