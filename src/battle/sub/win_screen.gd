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

@onready var WinXpLabel: Label = $win/Label

@onready var YokaiXpBar: ColorRect = $win/Sprite2D7/ColorRect


func set_win_xp(xp: int) -> void:
	gained_xp = xp
	WinXpLabel.text = str(xp)


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
	
	var new_level: int = global.player_yokai[0].get_new_level(xp)
	var level_difference: int = new_level - global.player_yokai[0].yokai_level
	var previous_xp: int = global.player_yokai[0].yokai_xp

	print("current_level: " + str(global.player_yokai[0].yokai_level))
	print("new_level: " + str(new_level))
	print("level_difference: " + str(level_difference))
	print("previous_xp: " + str(previous_xp))

	
	for i in range(level_difference + 1):
		var xp_scale: float = 0.0
		
		if level_difference != i:
			print_rich("[color=blue]level up[/color]")
			global.player_yokai[0].yokai_level += 1
			print("yokai level: " + str(global.player_yokai[0].yokai_level))
			global.player_yokai[0].yokai_xp = _cubed(global.player_yokai[0].yokai_level)
			xp_scale = 1.0
		else:
			print_rich("[color=red]add rest xp[/color]")
			print("xp: " + str(global.player_yokai[0].yokai_xp))
			global.player_yokai[0].yokai_xp = (xp - global.player_yokai[0].yokai_xp)
			xp_scale = float(global.player_yokai[0].yokai_xp) / float(_cubed(global.player_yokai[0].yokai_level + 1))
		
		var TweenInst: Tween = create_tween()
		TweenInst.tween_property(YokaiXpBar, "scale", Vector2(xp_scale, 1), 3)
		await TweenInst.finished
		YokaiXpBar.scale.x = 0.0
	

func _cubed(input: int) -> int:
	return input * input * input
