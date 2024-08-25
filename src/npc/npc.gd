class_name Npc extends CharacterBody2D


enum Behavoirs {
	STANDING = 0, # defualt
	MOVING = 1,
	WAITING = 2,
	SHOPKEEPING = 3,  
	QUEST = 4,
}


var points: Array[Vector2]
var times: Array[int]
var velocities: Array[Vector2]
var npc_data: Dictionary

var has_quest: bool = false


@export var current_behavior: Behavoirs = Behavoirs.STANDING
@export var npc_name: String = "NPC_01"
@export var repeating: bool = false
@export var quest_name: String = ""
@export var quest_progress: String = "start"

@onready var Sprite: Sprite2D = $sprite
@onready var Icon: Sprite2D = $icon 
@onready var MovementTween: Tween
@onready var QuestSprite: Sprite2D = $quest


func _ready() -> void:	
	_load()
	GlobalQuests.quest_update.connect(_load)


func _load() -> void:
	npc_data = global_npc.get_npc(npc_name)
	
	_load_npc_texture()
	_load_quest()
	_load_move()


func _load_npc_texture() -> void:
	Sprite.texture = load(npc_data["Sprite"])


func _load_quest() -> void:
	if quest_name == "":
		return
	
	has_quest = global_npc.npc_quests[quest_name][quest_progress]
	
	if has_quest:
		QuestSprite.visible = true
		current_behavior = Behavoirs.QUEST
	else:
		QuestSprite.visible = false
		current_behavior = Behavoirs.STANDING


func _load_move() -> void: 	
	if current_behavior == Behavoirs.MOVING:
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
				MovementTween = create_tween()
				MovementTween.tween_property(self, "position", points[i], abs(distance/velocities[i].x))
				
			elif velocities[i].y == 0:
				MovementTween = create_tween()
				MovementTween.tween_property(self, "position", points[i], abs(distance/velocities[i].x))
			
			await MovementTween.finished
			MovementTween.stop()
			
			if not repeating:
				return


func _on_hurtbox_area_entered(area: Area2D) -> void:	
	if area.name == "hurtbox":
		if current_behavior == Behavoirs.MOVING:
			current_behavior = Behavoirs.WAITING
			MovementTween.pause()
	
		Icon.visible = true
	

func _on_hurtbox_area_exited(area: Area2D) -> void:
	if area.name == "hurtbox":
		if current_behavior == Behavoirs.WAITING: 	
			await get_tree().create_timer(1).timeout

			current_behavior = Behavoirs.MOVING
			if MovementTween.is_valid():
				MovementTween.play()
		
		Icon.visible = false


func get_type() -> int:
	return current_behavior
