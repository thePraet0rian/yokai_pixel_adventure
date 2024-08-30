extends Node


signal quest_update
signal quest_interaction


const QUEST_ACCEPT_SCREEN: PackedScene = preload("res://scn/ui/quest/quest_accept_screen.tscn")
const QUEST_FINISH_SCREEN: int = 0


enum QuestStates {
	QUEST_OFF = 0,
	QUEST_STARTED = 1,
	QUEST_FINISHED = 2
}


var quests: Dictionary = {
	"Test": {
		"Activity": QuestStates.QUEST_OFF,
		"QuestStep": 0,
		"LastStep": 1
	}
}


func set_quest_activity(_quest_name: String) -> void:
	quests[_quest_name]["Activity"] = QuestStates.QUEST_STARTED
	quest_update.emit()


func _ready() -> void:
	quest_interaction.connect(_quest_interaction)


func _quest_interaction(_quest_name: String, _quest_progress: String) -> void:
	match _quest_name:
		"Test":
			_test_quest(_quest_progress) 


func _test_quest(_quest_progress: String) -> void:
	match _quest_progress:
		"start":
			print("quest test started")
			
			var QuestAcceptScreenInstance: CanvasLayer = QUEST_ACCEPT_SCREEN.instantiate()
			QuestAcceptScreenInstance.set_quest_name("Test")
			add_sibling(QuestAcceptScreenInstance)
			global_npc.npc_quests["Test"]["Second"] = true
			global_npc.npc_quests["Test"]["start"] = false
		"Second":
			global.on_dialogue_started.emit("NPC_01", 0)
			await global.on_dialogue_ended
			global_npc.npc_quests["Test"]["Second"] = false
	
	quest_update.emit()
			
