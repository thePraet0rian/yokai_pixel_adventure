class_name Npc 
extends CharacterBody2D

enum BEHAVIOR {WALKING = 0, STANDING = 1}

@export var points: Array[Vector2] = []
@export var times: Array[int] = []
@export var velocities: Array[Vector2] = []

@export var name_signal: String = "test_npc"

var current_index: int = 0
var current_behavior: BEHAVIOR = BEHAVIOR.WALKING

func _ready() -> void:
	
	for i in range(len(times)):
		if global.current_time >= times[i]:
			current_index = i
	
	position = points[current_index] + velocities[current_index] * global.current_time
	move()

@onready var tween: Tween = create_tween()

func move() -> void:
	
	for i in range(len(points)):
		
		var distance: float = position.distance_to(points[i])
		
		if velocities[i].x == 0:
			tween.tween_property(self, "position", points[i], (distance/velocities[i].y))
		else:
			tween.tween_property(self, "position", points[i], (distance/velocities[i].x))

@export var npc_name: String = "0"
@export var npc_int: int = 0

func _on_hurtbox_area_entered(_area: Area2D) -> void:
	
	current_behavior = BEHAVIOR.STANDING
	tween.pause()
 
func _on_hurtbox_area_exited(_area: Area2D) -> void:
	
	await get_tree().create_timer(1).timeout
	
	current_behavior = BEHAVIOR.WALKING
	if tween.is_valid():
		tween.play()
