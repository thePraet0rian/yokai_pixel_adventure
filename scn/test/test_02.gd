extends Node2D


const test_scn: PackedScene = preload("res://scn/battle/target.tscn")

func _ready() -> void:
	add_child(test_scn.instantiate())
	process_mode = Node.PROCESS_MODE_DISABLED
	
