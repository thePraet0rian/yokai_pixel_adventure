class_name Quests extends Node2D


signal quest_close


const QUEST_SCENE: PackedScene = preload("res://scn/player/menue/quests/quest_button.tscn")
const tmp_quest_arr: PackedStringArray = [
	"Test", 
	"test", 
	"test",
	"test",
	"test",
	"test",
	"test",
]


var index: int = 0
var QuestArr: Array = []


@onready var QuestOrganizer: Node2D = $Quests


func _ready() -> void:
	for i in range(len(tmp_quest_arr)):
		var QuestInstance: Sprite2D = QUEST_SCENE.instantiate()
		QuestOrganizer.add_child(QuestInstance)
		QuestArr.append(QuestInstance)
		QuestInstance.position = Vector2(120, 32) + Vector2(0, 28) * i
		
		if i == 0:
			QuestInstance.frame = 1


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_up"):
		if index > 2:
			create_tween().tween_property(QuestOrganizer, "position", QuestOrganizer.position + Vector2(0, 28), 0.15)
		if index > 0:
			index -= 1
	elif event.is_action_pressed("move_down"):
		if index > 1 and index < len(tmp_quest_arr) - 1:
			create_tween().tween_property(QuestOrganizer, "position", QuestOrganizer.position - Vector2(0, 28), 0.15)
		if index < len(tmp_quest_arr) - 1:
			index += 1
	
	if event.is_action_pressed("shift"):
		_end()
	
	if event.is_action_pressed("space"):
		_info()
	
	for i in range(len(QuestArr)):
		if index == i:
			QuestArr[i].frame = 1
		else:
			QuestArr[i].frame = 0


func _info() -> void:
	pass


func _end() -> void:
	await get_tree().physics_frame
	quest_close.emit(0)
	queue_free()
	
