class_name Shop extends CanvasLayer


@export var tmp_items: Array[String] = []

const ItemScene: PackedScene = preload("res://scn/ui/shop/item.tscn")

var shop_name: String = ""
var player_items: Array[Array] = global.player_inventory

var index: int = 0
var container_index: int = 0
var player_money: int = global.current_money

@onready var container: Node2D = $container
@onready var item_selector: Sprite2D = $container/selector
@onready var anim_player: AnimationPlayer = $anim_player
@onready var money_label: RichTextLabel = $money_label


func _ready() -> void:
	
	money_label.text = str(player_money)
	
	for i in range(len(tmp_items)):
		var ItemInst: Node2D = ItemScene.instantiate()
		ItemInst.position = Vector2(112, 32) + Vector2(0, 10) * i
		container.add_child(ItemInst)

#TODO: SCROLLING 
func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("shift"):
		anim_player.play("fade")
		await anim_player.animation_finished
		get_tree().paused = false
		global.on_menue_closed.emit()
		queue_free()
		
	if event.is_action_pressed("space"):
		_buy_items()
	
	if event.is_action_pressed("move_down"):
		if index < len(tmp_items) - 1:
			index += 1
	elif event.is_action_pressed("move_up"):
		if index > 0:
			index -= 1
	
	item_selector.position = Vector2(152, 36) + index * Vector2(0, 10)


func _buy_items() -> void:
	
	match shop_name:
		"NPC_01":
			_npc_01()


func _npc_01() -> void:
	
	var price: int = global_item.items[tmp_items[index]]["Price"]
	var difference: int = global.current_money - price
	var item_category: int = global_item.items[tmp_items[index]]["Category"]
	
	if difference > 0:
		global.current_money -= price
		_update_ui()
	
	print(tmp_items[index])
	
	var fuck: bool = false
	
	for i in range(len(global.player_inventory[item_category])):	
		
		if global.player_inventory[item_category][i].item_name == tmp_items[index]:
			global.player_inventory[item_category][i].item_count += 1
			fuck = true
	
	if not fuck:
		global.player_inventory[item_category].append(Item.new(tmp_items[index]))
	
	print(global.player_inventory)


func _update_ui() -> void:
	
	money_label.text = str(global.current_money)
