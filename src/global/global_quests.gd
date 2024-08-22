extends Node


signal quest_update
signal quest_interaction


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


func set_quest_activity(quest_name: String, activity: QuestStates) -> void:
	quests[quest_name]["Active"] = activity


func _ready() -> void:
	quest_interaction.connect(_quest_interaction)


func _quest_interaction(quest_name: String, quest_step: int) -> void:
	match quest_name:
		"Test":
			_quest_test(quest_step)


func _quest_test(quest_step: int) -> void:
	quests["QuestStep"] = quest_step
	
	match quest_step:
		0:
			quests["Activity"] = QuestStates.QUEST_STARTED
		1:
			pass
	
	quest_update.emit()
