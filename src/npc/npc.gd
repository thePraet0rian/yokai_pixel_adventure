class_name Npc extends CharacterBody2D


enum BEHAVIOR {WALKING = 0, STANDING = 1, WAITING = 2, SHOPKEEPING = 3}

@export var current_behavior: BEHAVIOR = BEHAVIOR.SHOPKEEPING
@export var npc_name: String = "NPC_01"
@export var repeating: bool = false

@onready var tween: Tween

var current_index: int = 0
var npc_int: int = 0

var points: Array[Vector2]
var times: Array[int]
var velocities: Array[Vector2]


func _ready() -> void:
	_load_npc()
	
	if current_behavior == BEHAVIOR.WALKING:
		position = points[0]
		move()


func _load_npc() -> void: 
	velocities.append_array(npc_manager.npcs[npc_name]["Velocities"])
	points.append_array(npc_manager.npcs[npc_name]["Points"])
	times.append_array(npc_manager.npcs[npc_name]["Times"])


func move() -> void:
	
	while true:
		for i in range(1, len(points)):
		
			var distance: float = position.distance_to(points[i])
		
			if velocities[i].x == 0:
				tween = create_tween()
				tween.tween_property(self, "position", points[i], abs(distance/velocities[i].x))
				
			elif velocities[i].y == 0:
				tween = create_tween()
				tween.tween_property(self, "position", points[i], abs(distance/velocities[i].x))
			
			await tween.finished
			tween.stop()
			
			if not repeating:
				return


func _on_hurtbox_area_entered(_area: Area2D) -> void:
	
	if current_behavior == BEHAVIOR.WALKING:
		current_behavior = BEHAVIOR.WAITING
		tween.pause()

 
func _on_hurtbox_area_exited(_area: Area2D) -> void:
	
	if current_behavior == BEHAVIOR.WAITING: 	
		await get_tree().create_timer(1).timeout

		current_behavior = BEHAVIOR.WALKING
		if tween.is_valid():
			tween.play()
