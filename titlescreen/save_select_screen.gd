extends Node2D


const room_scn: PackedScene = preload("res://main.tscn")
@onready var title_screen_scn: PackedScene = load("res://titlescreen/titlescreen.tscn")
 

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("space"):
		get_parent().add_child(room_scn.instantiate())
		global._on_load.emit(0)
		queue_free()
	
	if event.is_action_pressed("shift"):
		
		get_parent().add_child(title_screen_scn.instantiate())
		queue_free()
