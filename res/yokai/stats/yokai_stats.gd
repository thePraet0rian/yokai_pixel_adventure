extends Node


const path: String = "res://res/yokai/stats/yokai-stats.json"

var data: Dictionary


func _ready() -> void:
	
	var file = FileAccess.open(path, FileAccess.READ)
	data = JSON.parse_string(file.get_as_text())
