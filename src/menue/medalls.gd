extends Node2D


signal medalls_close


const YOKAI_SLOT_SCENE: PackedScene = preload("res://scn/ui/inventory/medalls/yokai_slot.tscn")
const tmp_quest_arr: Array[String] = [
	"test",
	"test",
	"test",
	"test",
	"test",
	"test",
	"test",
	"test",
	"test",
	"test",
	"test",
]


var YokaiArr: Array = []
var index: int = 0


@onready var YokaiOrganizer: Node2D = $Quests


func _ready() -> void:
	for i in range(len(tmp_quest_arr)):
		var YokaiSlotInstance: Sprite2D = YOKAI_SLOT_SCENE.instantiate()
		YokaiOrganizer.add_child(YokaiSlotInstance)
		YokaiArr.append(YokaiSlotInstance)
		YokaiSlotInstance.position = Vector2(112, 32) + Vector2(0, 18) * i
		


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_up"):
		if index > 2:
			create_tween().tween_property(YokaiOrganizer, "position", YokaiOrganizer.position + Vector2(0, 18 ), 0.15)
		if index > 0:
			index -= 1
	elif event.is_action_pressed("move_down"):
		if index > 1 and index < len(tmp_quest_arr) - 1:
			create_tween().tween_property(YokaiOrganizer, "position", YokaiOrganizer.position - Vector2(0, 18), 0.15)
		if index < len(tmp_quest_arr) - 1:
			index += 1
	
	for i in range(len(tmp_quest_arr)):
		if i == index:
			YokaiArr[i].frame = 1
		else: 
			YokaiArr[i].frame = 0
	
	if event.is_action_pressed("space"):
		print("test")
	elif event.is_action_pressed("shift"):
		_end()
	

func _end() -> void:
	medalls_close.emit(0)
	queue_free()
