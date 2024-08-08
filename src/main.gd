class_name Main extends Node2D



const PLAYER_SCENE: PackedScene = preload("res://scn/player/player.tscn")
const BATTLE_SCENE: PackedScene = preload("res://scn/battle/battle.tscn")
const EYEPO_SCENE: PackedScene = preload("res://scn/ui/eyepo/eyepo.tscn")
const SAVE_FILE_ARR: PackedStringArray = [
	"user://savefile_one.save",
	"user://savefile_two.save",
	"user://savefile_three.save",
]

@onready var UiHelperInstance: Ui = $ui
@onready var Rooms: Node2D = $rooms
@onready var PlayerInstance: Player = PLAYER_SCENE.instantiate()


var save_file_int: int 



func _on_game_loaded(_save_file: int) -> void:
	save_file_int = _save_file
	
	var load_file = FileAccess.open(SAVE_FILE_ARR[0], FileAccess.READ)
	var string = load_file.get_as_text()
	var data: Dictionary = JSON.parse_string(string)

	var new_room: Node2D = global.rooms[data["room"]].instantiate()

	Rooms.add_child(new_room)
	global.current_room = data["room"]

	Rooms.get_child(0).get_node("ysort").add_child(PlayerInstance)
	
	PlayerInstance.position.x = data["Player"]["posX"]
	PlayerInstance.position.y = data["Player"]["posY"]
	
	var inventory: Array[Array] = [[], [], [], [], []]
	
	for i in range(len(data["Inventory"])):
		for j in range(len(data["Inventory"][i])):
			inventory[i].append(Item.new(data["Inventory"][i][j]))
	
	for i in range(len(data["Team"])):
		global.player_yokai.append(Yokai.new(data["Team"][i]))

	global.player_inventory = inventory
	
	load_file.close()



func _ready() -> void:
	_connect_signals()



func _connect_signals() -> void:
	global.on_battle_started.connect(_on_battle_started)
	global.on_battle_ended.connect(_on_battle_ended)
	global.on_room_transitioned.connect(_on_room_transitioned)
	global.on_game_saved.connect(_on_game_saved)
	global.on_game_loaded.connect(_on_game_loaded)
	global.on_start_eyepo.connect(_start_eyepo)



func _on_battle_started(enemy_yokai_arr: Array[Yokai]) -> void:
	var BattleInstance: Battle = BATTLE_SCENE.instantiate()
	
	BattleInstance.set_player_yokai(global.player_yokai)
	BattleInstance.set_enemy_yokai(enemy_yokai_arr)
	
	add_child(BattleInstance)

		
		
func _on_battle_ended() -> void:
	get_tree().paused = false
	get_node("battle").queue_free()



func _on_room_transitioned(room: int) -> void:
	match room:
		1:
			Rooms.get_child(0).queue_free()
			
			var new_room: Node2D = global.rooms[room].instantiate()
			Rooms.add_child(new_room)
			
			global.current_room = 1
			
			PlayerInstance = PLAYER_SCENE.instantiate()			
			new_room.get_node("ysort").add_child(PlayerInstance )
			
			PlayerInstance.set_orientation(Vector2(-1, 0))
			PlayerInstance.position = Vector2(64, 64)



func _on_game_saved() -> void:
	var save_file = FileAccess.open(SAVE_FILE_ARR[save_file_int], FileAccess.WRITE)
	var inventory_names: Array[Array] = [[], [], [], [], []]
	
	for i in range(len(global.player_inventory)):
		for j in range(len(global.player_inventory[i])):
			inventory_names[i].append(global.player_inventory[i][j].item_name)
	
	var data: Dictionary = {
		"Player": {
			"posX": int(PlayerInstance.position.x),
			"posY": int(PlayerInstance.position.y),
		},
		"room": global.current_room,
		"Inventory": inventory_names,
	}

	var string = JSON.stringify(data)
	save_file.store_string(string)
	save_file.close()



func _on_main_timer_timeout() -> void:
	global.current_time += 1



func _start_eyepo() -> void:
	get_tree().paused = true
	add_child(EYEPO_SCENE.instantiate())
