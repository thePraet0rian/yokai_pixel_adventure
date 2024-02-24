class_name main
extends Node2D


func _ready() -> void:
	
	global.battle_start.connect(_on_battle_started)


const Battle: PackedScene = preload("res://battle/battle.tscn")


func _on_battle_started() -> void:
	
	var BattleInstance: battle = Battle.instantiate()
	add_child(Battle.instantiate())


func _on_area_2d_mouse_entered() -> void:
	print("fuck")


func _on_area_2d_mouse_shape_entered(shape_idx: int) -> void:
	print("wahta")
