class_name Inventory 
extends CanvasLayer

@onready var money_label: Label = $top_bar/money

func _ready() -> void:
	
	money_label.text = str(global.current_money)

var cur_pos: Vector2 = Vector2.ZERO

@onready var buttons: Array[Array] = [
	[$buttons/button_0, $buttons/button_3], 
	[$buttons/button_1, $buttons/button_4], 
	[$buttons/button_2, $buttons/button_5], 
	[$buttons/button_06, $buttons/button_06]]
@onready var anim_player: AnimationPlayer = $anim_player


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("shift"):
		anim_player.play("end")
	
	if event.is_action_pressed("space"):
		anim_player.play("enter")
	
	if event.is_action_pressed("move_up"):
		
		if cur_pos.y == 0:
			pass
		else:
			cur_pos.y -= 1
	if event.is_action_pressed("move_down"):
		
		if cur_pos.y == 1:
			pass
		else:
			cur_pos.y += 1
	if event.is_action_pressed("move_left"):
		
		if cur_pos.x == 0:
			pass
		else:
			cur_pos.x -= 1
	if event.is_action_pressed("move_right"):
		
		if cur_pos.x == 3:
			pass
		else:
			cur_pos.x += 1
	
	for i in range(len(buttons)):
		for j in range(len(buttons[i])):
			
			if not(i == cur_pos.x and j == cur_pos.y):
				buttons[i][j].frame = 0
	
	buttons[cur_pos.x][cur_pos.y].frame = 1

func end() -> void:
	
	global._on_menue_close.emit()
	get_tree().paused = false
	queue_free()
