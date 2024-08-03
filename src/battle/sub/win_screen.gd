extends Node2D


@onready var AnimPlayer: AnimationPlayer = $win/anim_player
@onready var Overlay: Node2D = $overlay


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space"):
		Overlay.visible = true
		AnimPlayer.play("fade")
		#_end()
		


func _end() -> void:
	global.on_battle_ended.emit()
	queue_free()
