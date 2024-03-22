class_name Main
extends Node2D


func _ready() -> void:
	
	global._on_battle_start.connect(_on_battle_started)


const Battle: PackedScene = preload("res://battle/battle.tscn")


func _on_battle_started() -> void:
	
	var BattleInstance: Battle = Battle.instantiate()
	add_child(BattleInstance)
	
	BattleInstance.set_player(global.player_yokai)
