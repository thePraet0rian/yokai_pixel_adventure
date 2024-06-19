extends Node2D


const ITEM_ICON_SCN: PackedScene = preload("res://scn/ui/inventory/item_icons.tscn")

@onready var Items: Node = $items
@onready var Selector: Sprite2D = $selector

var indices: Vector2 = Vector2.ZERO

func _ready() -> void:
	
	var y_index: int = 0
	
	for i in range(len(global.player_inventory[0])):
		
		if i % 3 == 0:
			y_index += 1
		
		var ItemIconInstance: ItemIcons = ITEM_ICON_SCN.instantiate()
		ItemIconInstance.item = global.player_inventory[0][i]
		ItemIconInstance.position = Vector2(32, 32) + Vector2(0, 16) * (i % 5) + Vector2(18, 0) * (y_index - 1)
		add_child(ItemIconInstance)


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("move_left"):
		if indices.x > 0:
			indices.x -= 1
	
	if event.is_action_pressed("move_right"):
		if indices.x < 12:
			indices.x += 1
	
	if event.is_action_pressed("move_up"):
		if indices.y > 0:
			indices.y -= 1
			
	if event.is_action_pressed("move_down"):
		if indices.y < 4:
			indices.y += 1
		
	Selector.position = Vector2(32, 32) + indices * Vector2(16, 16)
