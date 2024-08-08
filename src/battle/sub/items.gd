class_name Items extends Node2D


signal heal_yokai


const ITEM_ICON_SCN: PackedScene = preload("res://scn/ui/inventory/item_icons.tscn")


var indices: Vector2 = Vector2.ZERO


@onready var ItemSorter: Node = $items
@onready var Selector: Sprite2D = $selector


func _ready() -> void:
	var y_index: int = 0
	
	for i in range(len(global.player_inventory[0])):
		if i % 5 == 0:
			y_index += 1
		
		var ItemIconInstance: ItemIcons = ITEM_ICON_SCN.instantiate()
		ItemIconInstance.item = global.player_inventory[0][i]
		
		var x_direction_offset: Vector2 = Vector2(0, 16) * (i % 5)
		var y_direction_offset: Vector2 = Vector2(18, 0) * (y_index - 1)
		
		ItemIconInstance.position = Vector2(32, 32) + x_direction_offset + y_direction_offset
		ItemSorter.add_child(ItemIconInstance)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left"):
		if indices.x > 0:
			indices.x -= 1
	elif event.is_action_pressed("move_right"):
		if indices.x < 12:
			indices.x += 1
	elif event.is_action_pressed("move_up"):
		if indices.y > 0:
			indices.y -= 1		
	elif event.is_action_pressed("move_down"):
		if indices.y < 4:
			indices.y += 1
		
	Selector.position = Vector2(32, 32) + indices * Vector2(16, 16)

	if event.is_action_pressed("space"):
		var item_index: int = 5 * indices.x + indices.y
		_use_item(item_index) 


func _use_item(_item_index: int) -> void:
	var ItemInstance: Item = global.player_inventory[0][_item_index]
	var _health: int = global_item.HEALING_ITEMS[ItemInstance.item_name]["health"]
	heal_yokai.emit(_health)
	
