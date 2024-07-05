# --------------------------------------------------------------------------------------------------
## GLOBAL NPC CLASS
class_name Npc extends CharacterBody2D


enum Behavoirs {
	MOVING = 0, 
	STANDING = 1,
	WAITING = 2,
	SHOPKEEPING = 3,
}


@onready var Sprite: Sprite2D = $sprite

@export var current_behavior: Behavoirs = Behavoirs.SHOPKEEPING
@export var npc_name: String = "NPC_01"
@export var repeating: bool = false

@onready var tween: Tween


var current_index: int = 0
var npc_int: int = 0

var points: Array[Vector2]
var times: Array[int]
var velocities: Array[Vector2]


# Methods # ----------------------------------------------------------------------------------------


func _ready() -> void:
	
	_load_npc()
		
	if current_behavior == Behavoirs.MOVING:
		_load_move()
		

func _load_npc() -> void:
	
	Sprite.texture = load(global_npc.npc_sprites[npc_name])


func _load_move() -> void: 
	
	velocities.append_array(global_npc.moving_npcs[npc_name]["Velocities"])
	points.append_array(global_npc.moving_npcs[npc_name]["Points"])
	times.append_array(global_npc.moving_npcs[npc_name]["Times"])
	
	position = points[0]
	_move()


func _move() -> void:
	
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
	
	if current_behavior == Behavoirs.MOVING:
		current_behavior = Behavoirs.WAITING
		tween.pause()

 
func _on_hurtbox_area_exited(_area: Area2D) -> void:
	
	if current_behavior == Behavoirs.WAITING: 	
		await get_tree().create_timer(1).timeout

		current_behavior = Behavoirs.MOVING
		if tween.is_valid():
			tween.play()


# --------------------------------------------------------------------------------------------------
