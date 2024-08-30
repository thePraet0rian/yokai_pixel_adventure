class_name EnemyAi extends Ai


var CurrentYokaiInst: Yokai
var PlayerYokais: Array[Yokai] = [null, null, null]


func set_current_yokai(crr_yokai: Yokai) -> void:
	self.CurrentYokaiInst = crr_yokai


func set_players(player_arr: Array[BattleYokai]) -> void:
	for i in range(len(player_arr)):
		PlayerYokais[i] = player_arr[i].YokaiInst


func enemy_tick() -> void:
	if behavoir_barrier():
		match action():
			INSPIRITING:
				_enemy_grouchy_behavoir(INSPIRITING)
			ELEMENTAL_ATTACK:
				_enemy_grouchy_behavoir(ELEMENTAL_ATTACK)
			NORMAL_ATTACK:
				_enemy_grouchy_behavoir(NORMAL_ATTACK)


func _enemy_grouchy_behavoir(attack_type: int) -> void:
	
	if attack_type == INSPIRITING:
		for i in range(len(PlayerYokais)):
			if PlayerYokais[i].active and PlayerYokais[i].yokai_hp >= 0 and not PlayerYokais[i].inspirited:
				global.on_yokai_action.emit(1, CurrentYokaiInst.yokai_number, i, "inspirit", attack_type)
				return

	elif attack_type == ELEMENTAL_ATTACK or attack_type == NORMAL_ATTACK:
		for i in range(len(PlayerYokais)):
			if PlayerYokais[i].active and PlayerYokais[i].yokai_hp >= 0:
				global.on_yokai_action.emit(1, CurrentYokaiInst.yokai_number, i, "attack", attack_type)
				return
	
