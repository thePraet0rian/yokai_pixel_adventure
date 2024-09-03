extends Node2D


enum States {
	INITIAL = 0,
	RESULTS = 1,
}



var current_state: States = States.INITIAL
var gained_xp: int


@onready var AnimPlayer: AnimationPlayer = $win/anim_player
@onready var WinScreen: Node2D = $win
@onready var Overlay: Node2D = $overlay

@onready var YokaiXpBar: ColorRect = $win/Sprite2D7/ColorRect


func set_win_xp(xp: int) -> void:
	gained_xp = xp


func _input(event: InputEvent) -> void:
	match current_state:
		0:
			if event.is_action_pressed("space"):
				_add_xp(gained_xp)
				Overlay.visible = true
				AnimPlayer.play("fade")
				await AnimPlayer.animation_finished
				WinScreen.visible = true
				current_state = 1 as States
		1:
			if event.is_action_pressed("space"):
				_end()


func _end() -> void:
	await get_tree().physics_frame
	await get_tree().process_frame
	global.on_battle_ended.emit()
	queue_free()


# WARNING: UNCOMPLETE AND DOES THE WRONG THING
func _add_xp(xp: int) -> void:
	var returnArr: Array = global.player_yokai[0].experience(100)
	
	for i in range(returnArr[0]):
		await create_tween().tween_property(YokaiXpBar, "scale", Vector2(1, 1), .75).finished
		YokaiXpBar.scale = Vector2(0, 1)	
	
	await get_tree().create_tween().tween_property(YokaiXpBar, "scale", Vector2(global.player_yokai[0].yokai_exp_to_level / global.player_yokai[0]._calc_new_xp_to_level(), 1), 0.5)
	

func _cubed(input: int) -> int:
	return input * input * input
