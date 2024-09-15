class_name Items extends Node2D


enum States {
	INVENTORY = 0,
	YOKAI_SELECTOR = 1,
}


const ITEM_ICON_SCN: PackedScene = preload("res://scn/ui/inventory/item_icons.tscn")
const SELECTOR_POSITIONS: PackedVector2Array = [
	Vector2(24, 72), 
	Vector2(88, 72),
	Vector2(152, 72),
]


var current_state: States = States.INVENTORY
var yokai_selected: int = 0
var indices: Vector2 = Vector2.ZERO


@onready var ItemSorter: Node = $Inventory/Items
@onready var Selector: Sprite2D = $Inventory/Selector
@onready var Inventory: Node2D = $Inventory
@onready var YokaiSelector: Node2D = $YokaiSelector
@onready var SelectorRect: ColorRect = $YokaiSelector/Selector


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
	match current_state:
		0:
			_inventory_input(event)
		1:
			_yokai_input(event)


func _inventory_input(event: InputEvent) -> void:
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
		Inventory.visible = false
		YokaiSelector.visible = true
		current_state = States.YOKAI_SELECTOR


func _yokai_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left"):
		if yokai_selected > 0:
			yokai_selected -= 1
		else:
			yokai_selected = 2
	if event.is_action_pressed("move_right"):
		if yokai_selected < 2:
			yokai_selected += 1
		else:
			yokai_selected = 0
	
	SelectorRect.position = SELECTOR_POSITIONS[yokai_selected]
	
	if event.is_action_pressed("space"):
		var item_index: int = 5 * int(indices.x) + int(indices.y)
		_use_item(item_index)


func _use_item(_item_index: int) -> void:
	current_state = States.INVENTORY
	Inventory.visible = true
	YokaiSelector.visible = false
	
	var ItemInstance: Item = global.player_inventory[0][_item_index]
	var _health: int = global_item.HEALING_ITEMS[ItemInstance.item_name]["health"]
	global.on_yokai_action.emit("heal", 0, yokai_selected, -1)
	
