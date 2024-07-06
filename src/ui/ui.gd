# --------------------------------------------------------------------------------------------------
## GLOBAL UI CLASS
class_name Ui extends CanvasLayer


const DIALOGUE_SCENE: PackedScene = preload("res://scn/dialogue/dialogue.tscn")
const SHOP_SCENE: PackedScene = preload("res://scn/ui/shop/shop.tscn")


@onready var UiAnimPlayer: AnimationPlayer = $anim_player
@onready var UiOverlay: ColorRect = $overlay


# METHODS # ----------------------------------------------------------------------------------------
# Private: 


func _ready() -> void:
	
	global.on_dialogue_started.connect(start_dialogue)
	global.on_dialogue_ended.connect(end_dialogue)
	
	global.on_menue_closed.connect(close_menue)
	
	global.on_shopkeeper_met.connect(open_shop)


# Public:


func start_dialogue(npc_name: String, dialogue_int: int) -> void:
	
	var DialogueInstance: Dialogue = DIALOGUE_SCENE.instantiate()
	DialogueInstance.set_dialogue(npc_name, str(dialogue_int))
	add_child(DialogueInstance)


func end_dialogue() -> void:
	
	get_tree().paused = false


func open_shop(shop_name: String) -> void:
	
	var ShopInstance: Shop = SHOP_SCENE.instantiate()
	ShopInstance.shop_name = shop_name
	add_child(ShopInstance)


func close_menue() -> void:
	
	UiOverlay.visible = true
	UiAnimPlayer.play("fade_in")
	
	await UiAnimPlayer.animation_finished
	UiOverlay.visible = false
	
	UiAnimPlayer.play("RESET")


# --------------------------------------------------------------------------------------------------
