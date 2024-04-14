class_name Npc
extends CharacterBody2D



@export var points: Array[Vector2] = []
@export var times: Array[int] = []
@export var velocities: Array[Vector2] = []

@export var name_signal: String = "test_npc"


var current_index: int = 0


func _ready() -> void:
	
	
	for i in range(len(times)):
		
		if global.current_time >= times[i]:
			current_index = i
	
	position = points[current_index] + velocities[current_index] * global.current_time
	
	move()


func move() -> void:
	
	print(position)
	
	for i in range(len(points)):
		
		var distance: float = position.distance_to(points[i])
		
		if velocities[i].x == 0:
			create_tween().tween_property(self, "position", points[i], (distance/velocities[i].y))
		else:
			create_tween().tween_property(self, "position", points[i], (distance/velocities[i].x))
		
		await npc_manager.emit_signal(name_signal)
		print("npc_yes")

