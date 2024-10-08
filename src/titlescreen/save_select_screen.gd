class_name SaveSelectScreen extends Node2D


const main_scn: PackedScene = preload("res://scn/main.tscn")


var index: int = 0
var disabled: bool = false


@onready var title_screen_scn: PackedScene = load("res://src/titlescreen/titlescreen.tscn")
@onready var anim_player: AnimationPlayer = $anim_player
@onready var SaveButtons: Array[Sprite2D] = [
	$save_files/SaveButton,
	$save_files/SaveButton2,
	$save_files/SaveButton3
]

 
func _input(event: InputEvent) -> void:	
	if not disabled:
		if event.is_action_pressed("space"):
			disabled = true
			anim_player.play("fade_in")
			await anim_player.animation_finished
			
			get_parent().add_child(main_scn.instantiate())
			global.on_game_loaded.emit(0)
			global.on_menue_closed .emit()
						
			queue_free()
		
		if event.is_action_pressed("shift"):
			get_parent().add_child(title_screen_scn.instantiate())
			queue_free()
			
		if event.is_action_pressed("move_down"):
			if index < 2: 
				index += 1
		if event.is_action_pressed("move_up"):
			if index > 0:
				index -= 1
		
		for i in range(len(SaveButtons)):
			if i == index:
				SaveButtons[i].frame = 1
			else:
				SaveButtons[i].frame = 0
