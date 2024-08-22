class_name Npc extends CharacterBody2D


enum Behavoirs {
	MOVING = 0, 
	STANDING = 1,
	WAITING = 2,
	SHOPKEEPING = 3,
	QUEST = 4,
}


var current_index: int = 0
var npc_int: int = 0
var has_quest: bool = false

var points: Array[Vector2]
var times: Array[int]
var velocities: Array[Vector2]


@export var current_behavior: Behavoirs = Behavoirs.SHOPKEEPING
@export var current_quest: String = ""
@export var npc_name: String = "NPC_01"
@export var repeating: bool = false

@onready var Sprite: Sprite2D = $sprite
@onready var icon: Sprite2D = $icon 
@onready var tween: Tween
@onready var QuestSprite: Sprite2D = $quest


func _ready() -> void:	
	_load_npc()
	_load_quest()
	
	if current_behavior == Behavoirs.MOVING:
		_load_move()
	
	GlobalQuests.quest_update.connect(_update)


func _update() -> void:
	var npc_data: Dictionary = global_npc.get_npc("npc_name")


func _load_npc() -> void:
	Sprite.texture = load(global_npc.npc_sprites[npc_name])


func _load_quest() -> void:
	match current_quest:
		"":
			return
		"Test":
			QuestSprite.visible = true
			has_quest = true


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


func _on_hurtbox_area_entered(area: Area2D) -> void:	
	if area.name == "hurtbox":
		if current_behavior == Behavoirs.MOVING:
			current_behavior = Behavoirs.WAITING
			tween.pause()
	
		icon.visible = true
	

func _on_hurtbox_area_exited(area: Area2D) -> void:
	if area.name == "hurtbox":
		if current_behavior == Behavoirs.WAITING: 	
			await get_tree().create_timer(1).timeout

			current_behavior = Behavoirs.MOVING
			if tween.is_valid():
				tween.play()
		
		icon.visible = false


func get_type() -> int:
	return current_behavior
