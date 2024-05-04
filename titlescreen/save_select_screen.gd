extends Node2D


const room_scn: PackedScene = preload("res://main.tscn")
#const title_screen_scn: PackedScene = preload("res://titlescreen/titlescreen.tscn")
 

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("space"):
		get_parent().add_child(room_scn.instantiate())
		global._on_load.emit(0)
		queue_free()
	
	if event.is_action_pressed("shift"):
		
		pass
		queue_free()
