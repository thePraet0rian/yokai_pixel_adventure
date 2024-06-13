extends Node2D


signal _sig_inventory_close

@onready var select: Sprite2D = $Sprite2D/select
@onready var inventory_anim_player: AnimationPlayer = $inventory_anim_player

@onready var sub_inventories: Array[Node2D] = [
	$sub_inventories/food,
	$sub_inventories/items, 
	$sub_inventories/animals,
	$sub_inventories/equip,
	$sub_inventories/key,
]

@onready var sub_selector: Array[Sprite2D] = [
	$sub_inventories/food/select,
	$sub_inventories/items/select,
	$sub_inventories/animals/select,
	$sub_inventories/equip/select, 
	$sub_inventories/key/select,
]

var inventory_page: int = 0

var indices: Array[Vector2] = [
	Vector2.ZERO,
	Vector2.ZERO,
	Vector2.ZERO,
	Vector2.ZERO,
	Vector2.ZERO,
]


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("move_wheel_left"):
		if inventory_page > 0:
			select.position.x -= 22
			inventory_page -= 1
	elif event.is_action_pressed("move_wheel_right"):
		if inventory_page < 4:
			select.position.x += 22
			inventory_page += 1
	
	for i in range(0, 5):		
		sub_inventories[i].visible = true if i == inventory_page else false
	
	if event.is_action_pressed("move_left"):
		if indices[inventory_page].x > 0:
			indices[inventory_page].x -= 1
	elif event.is_action_pressed("move_right"):
		if indices[inventory_page].x < 10:
			indices[inventory_page].x += 1
	elif event.is_action_pressed("move_up"):
		if indices[inventory_page].y > 0:
			indices[inventory_page].y -= 1
	elif event.is_action_pressed("move_down"):
		if indices[inventory_page].y < 2:
			indices[inventory_page].y += 1
	
	sub_selector[inventory_page].position = Vector2(24, 60) + Vector2(18, 18) * indices[inventory_page]
	
	if event.is_action_pressed("space"):
		inventory_anim_player.play("enter")
	
	if event.is_action_pressed("shift"):
		inventory_anim_player.play("end")
		await inventory_anim_player.animation_finished
		_sig_inventory_close.emit()
		queue_free()
