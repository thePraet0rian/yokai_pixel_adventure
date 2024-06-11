extends Node


var npcs: Dictionary


func _ready() -> void:
	
	var file = FileAccess.open("res://src/npc/npcs.json", FileAccess.READ)
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
		
		
		npcs[data[i]["Name"]] = {"Points": points, "Velocities": velocities, "Times": times, "Sprite": sprite}
	
	print(npcs)
	
