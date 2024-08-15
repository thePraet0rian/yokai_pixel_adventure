extends Node2D


enum States {
	INITIAL = 0,
	RESULTS = 1,
}


@onready var AnimPlayer: AnimationPlayer = $win/anim_player
@onready var WinScreen: Node2D = $win
@onready var Overlay: Node2D = $overlay

var current_state: States = States.INITIAL


func _input(event: InputEvent) -> void:
	match current_state:
		0:
			if event.is_action_pressed("space"):
				Overlay.visible = true
				AnimPlayer.play("fade")
				await AnimPlayer.animation_finished
				WinScreen.visible = true
				current_state = 1
		1:
			if event.is_action_pressed("space"):
				_end()


func _end() -> void:
	await get_tree().physics_frame
	await get_tree().process_frame
	global.on_battle_ended.emit()
	queue_free()
