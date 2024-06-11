class_name SaveSelectScreen extends Node2D


const main_scn: PackedScene = preload("res://scn/main.tscn")

@onready var title_screen_scn: PackedScene = load("res://src/titlescreen/titlescreen.tscn")
@onready var anim_player: AnimationPlayer = $anim_player

 
func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("space"):
		anim_player.play("fade_in")
		await anim_player.animation_finished
		
		get_parent().add_child(main_scn.instantiate())
		global.on_game_loaded.emit(0)
		global.on_menue_closed.emit()
		
		queue_free()
	
	if event.is_action_pressed("shift"):
		get_parent().add_child(title_screen_scn.instantiate())
		queue_free()
