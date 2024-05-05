extends Node2D


var save_select_scn: PackedScene = preload("res://titlescreen/save_select_screen.tscn")


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("space"):
		
		get_parent().add_child(save_select_scn.instantiate())
		queue_free()
