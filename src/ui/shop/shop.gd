class_name Shop extends CanvasLayer


@export var items: Array[String] = []

const ItemScene: PackedScene = preload("res://scn/ui/shop/item.tscn")

var shop: String = ""
var player_items: Array[Array] = global.player_inventory

var index: int = 0
var container_index: int = 0

@onready var container: Node2D = $container
@onready var item_selector: Sprite2D = $container/selector
@onready var anim_player: AnimationPlayer = $anim_player


func _ready() -> void:
	
	for i in range(len(items)):
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
		pass
	
	if event.is_action_pressed("move_down"):
		if index < len(items) - 1:
			index += 1
	elif event.is_action_pressed("move_up"):
		if index > 0:
			index -= 1
	
	item_selector.position = Vector2(152, 36) + index * Vector2(0, 10)

