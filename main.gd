class_name Main
extends Node2D


func _ready() -> void:
	
	global._on_battle_start.connect(_on_battle_started)
	global._on_room_changing.connect(_on_room_changing)
	global._on_warp.connect(_on_warp)
	global._on_save.connect(_on_save)
	global._on_load.connect(_on_load)
	global._on_dialogue.connect(_on_dialogue)


const BattleScene: PackedScene = preload("res://battle/battle.tscn")


func _on_battle_started() -> void:
	
	var BattleInstance: Battle = BattleScene.instantiate()
	add_child(BattleInstance)
	
	BattleInstance.set_player(global.player_yokai)


const room_02: PackedScene = preload("res://rooms/room_02.scn")


func _on_room_changing(room: int) -> void:
	
	match room:
		
		0:
			get_tree().change_scene_to_packed(room_02)
			queue_free()
			#TODO: FIX THIS SHIT THANK YOU VERY MUCH


func _on_warp(warp: int) -> void:
	
	match warp: 
		
		0:
			pass


const save_file_arr: Array[String] = ["user://savefile_one.save", "user://savefile_two.save", "user://savefile_three.save"]


var save_file: int 


func _on_load(_save_file: int) -> void:
	
	
	save_file = _save_file
	
	var load_file = FileAccess.open(save_file_arr[save_file], FileAccess.READ)
	
	var _inventory_length: int = load_file.get_8()
	
	for i in range(3):
		print(load_file.get_var())
	
	load_file.close()


func _on_save() -> void:
	
	var save_file = FileAccess.open(save_file_arr[save_file], FileAccess.WRITE)
	
	save_file.store_8(3)
	
	for i in range(len(global.player_inventory)):
		save_file.store_var(global.player_inventory[i].name_str)
		save_file.store_var(global.player_inventory[i].description)
		save_file.store_var(global.player_inventory[i].sprite)
	
	save_file.close()


func _on_main_timer_timeout() -> void:
	
	global.current_time += 1


const dialogue_scn: PackedScene = preload("res://dialogue/dialogue.tscn")


func _on_dialogue(npc_name: String, dialogue_int: int) -> void:
	
	get_tree().paused = true
	var DialogueInstance: Dialogue = dialogue_scn.instantiate()
	add_child(DialogueInstance)
	DialogueInstance.get_dialogue()

