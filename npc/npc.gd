class_name Npc extends CharacterBody2D


enum BEHAVIOR {WALKING = 0, STANDING = 1}

@export var points: Array[Vector2] = []
@export var times: Array[int] = []
@export var velocities: Array[Vector2] = []

@export var repeating: bool = false
@export var name_signal: String = "test_npc"

var current_index: int = 0
var current_behavior: BEHAVIOR = BEHAVIOR.WALKING


func _ready() -> void:
	

	print(points)
	position = points[0]
	move()


@onready var tween: Tween


func move() -> void:
	
	while true:
		for i in range(1, len(points)):
		
			var distance: float = position.distance_to(points[i])
			print(distance)
		
			if velocities[i].x == 0:
				tween = create_tween()
				tween.tween_property(self, "position", points[i], abs(distance/velocities[i].x))
				
			elif velocities[i].y == 0:
				tween = create_tween()
				tween.tween_property(self, "position", points[i], abs(distance/velocities[i].x))
			
			await tween.finished
			tween.stop()
			print("why" + name)
			
			if not repeating:
				return



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
