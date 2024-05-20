class_name Inventory extends CanvasLayer


enum STATES {
	MAIN = 0, 
	INVENTORY = 1, 
	SAVE = 2, 
	MEDALS = 3, 
	TEAM = 4,
}

@onready var money_label: Label = $main/top_bar/money
@onready var anim_player: AnimationPlayer = $main/anim_player

@onready var buttons: Array[Array] = [
	[$main/buttons/button_0, $main/buttons/button_3], 
	[$main/buttons/button_1, $main/buttons/button_4], 
	[$main/buttons/button_2, $main/buttons/button_5], 
	[$main/buttons/button_06, $main/buttons/button_06],
]

@onready var sub_ui: Array[Node2D] = [
	$sub_ui/inventory,
]

var cur_pos: Vector2 = Vector2.ZERO
var current_state: STATES = STATES.MAIN


func _ready() -> void:
	money_label.text = str(global.current_money)


func _input(event: InputEvent) -> void:
	
	match current_state:
		0:
			main_menue_input(event)
		1:
			inventory_input(event)
		2:
			pass
		3:
			pass
		4:
			pass
		5:
			pass


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
		
		if cur_pos.x == 0 and cur_pos.y == 0:
			current_state = STATES.INVENTORY
			sub_ui[0].visible = true
			
	
	for i in range(len(buttons)):
		for j in range(len(buttons[i])):
			
			if not(i == cur_pos.x and j == cur_pos.y):
				buttons[i][j].frame = 0
	
	buttons[cur_pos.x][cur_pos.y].frame = 1


@onready var select: Sprite2D = $sub_ui/inventory/Sprite2D/select

@onready var sub_inventories: Array[Node2D] = [
	$sub_ui/inventory/sub_inventories/food,
	$sub_ui/inventory/sub_inventories/items, 
	$sub_ui/inventory/sub_inventories/animals,
	$sub_ui/inventory/sub_inventories/equip,
	$sub_ui/inventory/sub_inventories/key,
]

@onready var sub_selector: Array[Sprite2D] = [
	$sub_ui/inventory/sub_inventories/food/select,
	$sub_ui/inventory/sub_inventories/items/select,
	$sub_ui/inventory/sub_inventories/animals/select,
	$sub_ui/inventory/sub_inventories/animals/select, 
	$sub_ui/inventory/sub_inventories/equip/select, 
	$sub_ui/inventory/sub_inventories/key/select,
]

var inventory_page: int = 0

var indices: Array[Vector2] = [
	Vector2.ZERO,
	Vector2.ZERO,
	Vector2.ZERO,
	Vector2.ZERO,
	Vector2.ZERO,
]


func inventory_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("move_wheel_left"):
		select.position.x -= 22
	elif event.is_action_pressed("move_wheel_right"):
		select.position.x += 22
	
	indices[inventory_page].x += Input.get_axis("move_left", "move_right")
	indices[inventory_page].y += Input.get_axis("move_up", "move_down")
	
	sub_selector[inventory_page].position = Vector2(24, 60) + Vector2(18, 18) * indices[inventory_page]
	
	
func end() -> void:	
	global._on_menue_close.emit()
	get_tree().paused = false
	queue_free()
