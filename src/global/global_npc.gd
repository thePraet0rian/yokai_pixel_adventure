class_name GlobalNpc extends Node


const NPC_SPRITES_PATH: String = "res://src/npc/data/npc_sprites.json"
const MOVING_NPC_PATH: String = "res://src/npc/npcs.json"
const TALKING_NPC_PATH: String = "res://src/npc/test.json"


var npc_sprites: Dictionary
var moving_npcs: Dictionary
var talking_npcs: Dictionary
var npc_expressions: Dictionary


func _ready() -> void:
	_load_npc_sprites()
	_load_moving_npcs()
	_load_talking_npcs()
	_load_npc_dialogue_expressions()


func _load_npc_sprites() -> void:
	var file = FileAccess.open(NPC_SPRITES_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	
	npc_sprites = data
	
	file.close()


func _load_moving_npcs() -> void:
	var file = FileAccess.open(MOVING_NPC_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	
	for i in range(len(data)): 

		var points: Array[Vector2] = []
		var velocities: Array[Vector2] = []
		var times: Array[int] = []
		var sprite: String
		
		for j in range(len(data[i]["Points"])):
			
			var point_x: float = data[i]["Points"][j][0]
			var point_y: float = data[i]["Points"][j][1]
			points.append(Vector2(point_x, point_y))
			
			var vel_x: float = data[i]["Velocities"][j][0]
			var vel_y: float = data[i]["Velocities"][j][1]
			velocities.append(Vector2(vel_x, vel_y))
			
			times.append(int(data[i]["Times"][j]))
			
			sprite = data[i]["Sprite"]
		
		
		moving_npcs[data[i]["Name"]] = {"Points": points, "Velocities": velocities, "Times": times, "Sprite": sprite}
		
	file.close()
	

func _load_talking_npcs() -> void:
	var file = FileAccess.open(TALKING_NPC_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	
	talking_npcs = data
	file.close()


func _load_npc_dialogue_expressions() -> void:
	var file = FileAccess.open("res://src/npc/data/npc_expressions.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	
	npc_expressions = data
	file.close()


func get_npc(npc_name: String) -> Dictionary:
	
	return {}
