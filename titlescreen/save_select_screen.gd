class_name SaveSelectScreen extends Node2D


const room_scn: PackedScene = preload("res://main.tscn")

@onready var title_screen_scn: PackedScene = load("res://titlescreen/titlescreen.tscn")
@onready var anim_player: AnimationPlayer = $anim_player

 
func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("space"):
		
		anim_player.play("fade_in")
		await anim_player.animation_finished
		
		get_parent().add_child(room_scn.instantiate())
		global._on_load.emit(0)
		global._on_menue_close.emit()
		
		queue_free()
	
	if event.is_action_pressed("shift"):
		
		get_parent().add_child(title_screen_scn.instantiate())
		queue_free()
