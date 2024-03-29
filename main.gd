class_name Main
extends Node2D


func _ready() -> void:
	
	global._on_battle_start.connect(_on_battle_started)
	global._on_room_changing.connect(_on_room_changing)


const BattleScene: PackedScene = preload("res://battle/battle.tscn")


func _on_battle_started() -> void:
	
	var BattleInstance: Battle = BattleScene.instantiate()
	add_child(BattleInstance)
	
	BattleInstance.set_player(global.player_yokai)


func _on_room_changing(room: int) -> void:
	
	print("room change")
	print(room)
