extends Node2D


const ITEM_ICON_SCN: PackedScene = preload("res://scn/ui/inventory/item_icons.tscn")

@onready var Items: Node = $items


func _ready() -> void:
	
	var y_index: int = 0
	
	for i in range(len(global.player_inventory[0])):
		
		if i % 3 == 0:
			y_index += 1
		
		var ItemIconInstance: ItemIcons = ITEM_ICON_SCN.instantiate()
		ItemIconInstance.item = global.player_inventory[0][i]
		ItemIconInstance.position = Vector2(32, 32) + Vector2(0, 16) * (i % 5) + Vector2(18, 0) * (y_index - 1)
		add_child(ItemIconInstance)
