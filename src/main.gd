class_name Main extends Node2D


const PLAYER_SCENE: PackedScene = preload("res://scn/player/player.tscn")
const DIALOGUE_SCENE: PackedScene = preload("res://scn/dialogue/dialogue.tscn")
const BATTLE_SCENE: PackedScene = preload("res://scn/battle/battle.tscn")
const SHOP_SCENE: PackedScene = preload("res://scn/ui/shop/shop.tscn")

const SAVE_FILE_ARR: Array[String] = [
	"user://savefile_one.save", 
	"user://savefile_two.save", 
	"user://savefile_three.save"
]

@onready var Rooms: Node2D = $rooms
@onready var PlayerInst: Player = Rooms.get_child(0).get_node("ysort").get_node("player")
@onready var UiAnimPlayer: AnimationPlayer = $ui/anim_player
@onready var UiOverlay: ColorRect = $ui/ColorRect

var save_file_int: int 


func _on_game_loaded(_save_file: int) -> void:
	
	save_file_int = _save_file
	var load_file = FileAccess.open(SAVE_FILE_ARR[0], FileAccess.READ)
	var string = load_file.get_as_text()
	var data: Dictionary = JSON.parse_string(string)
	
	PlayerInst.position.x = data["Player"]["posX"]
	PlayerInst.position.y = data["Player"]["posY"]
	
	load_file.close()
	

func _ready() -> void:
	
	global.on_battle_started.connect(_on_battle_started)
	global.on_battle_ended.connect(_on_battle_ended)
	
	global.on_room_transitioned.connect(_on_room_transitioned)
	
	global.on_game_saved.connect(_on_game_saved)
	global.on_game_loaded.connect(_on_game_loaded)
	
	global.on_dialogue_started.connect(_on_dialogue_started)
	global.on_dialogue_ended.connect(_on_dialogue_ended)
	
	global.on_menue_closed.connect(_on_menue_closed)
	
	global.on_shopkeeper_met.connect(_on_shopkeeper_met)
	
	global.on_test_start.connect(_on_test_start)
	
	global.disable_main.connect(_on_disable_main)


func _on_battle_started(enemy_yokai_arr: Array[Yokai]) -> void:
	
	var BattleInstance: Battle = BATTLE_SCENE.instantiate()	
	BattleInstance.player_yokai_arr = global.player_yokai
	BattleInstance.enemy_yokai_arr = enemy_yokai_arr.duplicate()
	add_child(BattleInstance)
		
func _on_battle_ended() -> void:
	
	get_tree().paused = false


func _on_room_transitioned(room: int) -> void:
	
	match room:	
		1:
			Rooms.get_child(0).queue_free()
			
			var new_room: Node2D = global.rooms[1].instantiate()
			Rooms.add_child(new_room)
			
			PlayerInst = PLAYER_SCENE.instantiate()			
			new_room.get_node("ysort").add_child(PlayerInst)
			
			PlayerInst.set_orientation(Vector2(-1, 0))
			PlayerInst.position = Vector2(64, 64)


func _on_game_saved() -> void:

	var save_file = FileAccess.open(SAVE_FILE_ARR[save_file_int], FileAccess.WRITE)
	var data: Dictionary = {
		"Player": {
			"posX": int(PlayerInst.position.x),
			"posY": int(PlayerInst.position.y),
		}
	}	
	
	var string = JSON.stringify(data)
	save_file.store_string(string)	
	save_file.close()


func _on_dialogue_started(npc_name: String, dialogue_int: int) -> void:
	
	var DialogueInstance: Dialogue = DIALOGUE_SCENE.instantiate()
	DialogueInstance.set_dialogue(npc_name, str(dialogue_int))
	add_child(DialogueInstance)


func _on_dialogue_ended() -> void:
	
	get_tree().paused = false


func _on_menue_closed() -> void:
	
	UiOverlay.visible = true
	UiAnimPlayer.play("fade_in")
	
	await UiAnimPlayer.animation_finished
	UiOverlay.visible = false
	
	UiAnimPlayer.play("RESET")


func _on_main_timer_timeout() -> void:
	
	global.current_time += 1


func _on_shopkeeper_met(shopkeep_name: String) -> void:
	
	var ShopInstance: Shop = SHOP_SCENE.instantiate()
	ShopInstance.shop_name = shopkeep_name
	add_child(ShopInstance)
	

func _on_test_start() -> void:
	
	#add_child(TEST_SCENE.instantiate())
	#get_tree().paused = true
	pass


func _on_disable_main() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	print("disabeld")
