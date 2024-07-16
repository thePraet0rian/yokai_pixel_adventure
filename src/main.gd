# --------------------------------------------------------------------------------------------------
## MAIN GAME CLASS
class_name Main extends Node2D


const PLAYER_SCENE: PackedScene = preload("res://scn/player/player.tscn")
const BATTLE_SCENE: PackedScene = preload("res://scn/battle/battle.tscn")


const SAVE_FILE_ARR: Array[String] = [
	"user://savefile_one.save", 
	"user://savefile_two.save", 
	"user://savefile_three.save",
]


@onready var UiHelperInstance: Ui = $ui

@onready var Rooms: Node2D = $rooms
@onready var PlayerInstance: Player = PLAYER_SCENE.instantiate()


var save_file_int: int 


# Private Methods # --------------------------------------------------------------------------------


func _on_game_loaded(_save_file: int) -> void:
	
	save_file_int = _save_file
	var load_file = FileAccess.open(SAVE_FILE_ARR[0], FileAccess.READ)
	var string = load_file.get_as_text()
	var data: Dictionary = JSON.parse_string(string)

	# Instance Room
	var new_room: Node2D = global.rooms[data["room"]].instantiate()
	Rooms.add_child(new_room)

	# Instance Player
	Rooms.get_child(0).get_node("ysort").add_child(PlayerInstance)
	# Set Player Position
	PlayerInstance.position.x = data["Player"]["posX"]
	PlayerInstance.position.y = data["Player"]["posY"]
	
	
	load_file.close()
	

func _ready() -> void:
	
	global.on_battle_started.connect(_on_battle_started)
	global.on_battle_ended.connect(_on_battle_ended)
	
	global.on_room_transitioned.connect(_on_room_transitioned)
	
	global.on_game_saved.connect(_on_game_saved)
	global.on_game_loaded.connect(_on_game_loaded)


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
			
			var new_room: Node2D = global.rooms[room].instantiate()
			Rooms.add_child(new_room)
			
			global.current_room = 1
			
			PlayerInstance = PLAYER_SCENE.instantiate()			
			new_room.get_node("ysort").add_child(PlayerInstance )
			
			PlayerInstance.set_orientation(Vector2(-1, 0))
			PlayerInstance.position = Vector2(64, 64)


func _on_game_saved() -> void:

	var save_file = FileAccess.open(SAVE_FILE_ARR[save_file_int], FileAccess.WRITE)
	
	var data: Dictionary = {
		"Player": {
			"posX": int(PlayerInstance.position.x),
			"posY": int(PlayerInstance.position.y),
		}, 
		"room": global.current_room,
	}	
	
	var string = JSON.stringify(data)
	save_file.store_string(string)	
	save_file.close()


func _on_main_timer_timeout() -> void:
	
	global.current_time += 1


# --------------------------------------------------------------------------------------------------
