class_name Inventory extends CanvasLayer


const InventoryScene: PackedScene = preload("res://scn/menue/inventory.tscn")
 
enum STATES {
	MAIN = 0, 
	INVENTORY = 1, 
	SAVE = 2, 
	MEDALS = 3, 
	TEAM = 4,
}

@onready var money_label: Label = $main/top_bar/money
@onready var anim_player: AnimationPlayer = $main/anim_player
@onready var sub_inventory: Node2D = $sub_ui

@onready var buttons: Array[Array] = [
	[$main/buttons/button_0, $main/buttons/button_3], 
	[$main/buttons/button_1, $main/buttons/button_4], 
	[$main/buttons/button_2, $main/buttons/button_5], 
	[$main/buttons/button_06, $main/buttons/button_06],
]

var cur_pos: Vector2 = Vector2.ZERO
var current_state: STATES = STATES.MAIN


func _ready() -> void:
	money_label.text = str(global.current_money)


func _input(event: InputEvent) -> void:
	match current_state:
		0:
			main_menue_input(event)


func main_menue_input(event: InputEvent) -> void:
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
	
	if event.is_action_pressed("shift"):
		anim_player.play("end")
	
	if event.is_action_pressed("space"):
		anim_player.play("enter")
		await anim_player.animation_finished
		
		match_main_input()
	
	for i in range(len(buttons)):
		for j in range(len(buttons[i])):
			
			if not(i == cur_pos.x and j == cur_pos.y):
				buttons[i][j].frame = 0
	
	buttons[cur_pos.x][cur_pos.y].frame = 1


func match_main_input() -> void:
	
	if cur_pos.x == 0 and cur_pos.y == 0:
		var inventory_inst: Node2D = InventoryScene.instantiate()
		sub_inventory.add_child(inventory_inst)
		inventory_inst._sig_inventory_close.connect(inventory_close)
		current_state = STATES.INVENTORY
	if cur_pos.x == 1 and cur_pos.y == 0:
		global.on_game_saved.emit()


func inventory_close() -> void:
	current_state = STATES.MAIN


func end() -> void:	
	global.on_menue_closed.emit()
	get_tree().paused = false
	queue_free()
