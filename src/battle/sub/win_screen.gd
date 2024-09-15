extends Node2D


enum States {
	INITIAL = 0,
	RESULTS = 1,
	END = 2,
	
}


var current_state: States = States.INITIAL
var gained_xp: int


@onready var YouWinSprite: Sprite2D = $YouWinSprite

@onready var AnimPlayer: AnimationPlayer = $win/AnimPlayer
@onready var WinScreen: Node2D = $win

@onready var Yokais: Array[Sprite2D] = [
	$win/Yokais/ResultYokai,
	$win/Yokais/ResultYokai2,
	$win/Yokais/ResultYokai3,
	$win/Yokais/ResultYokai4,
	$win/Yokais/ResultYokai5,
	$win/Yokais/ResultYokai6,
]


func set_win_xp(xp: int) -> void:
	gained_xp = xp


func _input(event: InputEvent) -> void:
	match current_state:
		0:
			if event.is_action_pressed("space"):
				YouWinSprite.visible = false
				WinScreen.visible = true
				
				for i in range(len(Yokais)):
					Yokais[i].set_xp(gained_xp)
					Yokais[i].set_yokai(i)
					Yokais[i]._start()
				
				current_state = 2 as States
			
			global.current_money += 100 # CALCULATE THE MONEY
			
		1:
			pass
			
		2:
			if event.is_action_pressed("space"):
				_end()


func _end() -> void:
	await get_tree().physics_frame
	await get_tree().process_frame
	global.on_battle_ended.emit()
	queue_free()

	

func _cubed(input: int) -> int:
	return input * input * input
