class_name main
extends Node2D


func _ready() -> void:
	
	global._on_battle_start.connect(_on_battle_started)


const Battle: PackedScene = preload("res://battle/battle.tscn")


func _on_battle_started() -> void:
	
	var BattleInstance: battle = Battle.instantiate()
	add_child(BattleInstance)
	
	var yokai_one: global.Yokai = global.Yokai.new(10.0)
	
	BattleInstance.set_player([yokai_one])
