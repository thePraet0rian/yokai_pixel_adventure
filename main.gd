class_name Main
extends Node2D


func _ready() -> void:
	
	global._on_battle_start.connect(_on_battle_started)
	global._on_room_changing.connect(_on_room_changing)
	global._on_warp.connect(_on_warp)


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


func _on_warp(warp: int) -> void:
	
	match warp: 
		
		0:
			pass
