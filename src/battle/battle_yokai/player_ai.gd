class_name PlayerAi extends Ai


var CurrentYokaiInst: Yokai
var EnemyYokais: Array[Yokai] = [null, null, null]


func set_current_yokai(crr_yokai: Yokai) -> void:
	self.CurrentYokaiInst = crr_yokai


func set_enemys(enemy_arr: Array[BattleYokai]) -> void:
	for i in range(len(enemy_arr)):
		EnemyYokais[i] = enemy_arr[i].YokaiInst


func player_tick() -> void:
	if behavoir_barrier():
		match action():
			INSPIRITING:
				_player_behavoir(INSPIRITING)
			ELEMENTAL_ATTACK:
				_player_behavoir(ELEMENTAL_ATTACK)
			NORMAL_ATTACK:
				_player_behavoir(NORMAL_ATTACK)
			_:
				push_error("ACTION() GENERATED AN INVALID RESULT")


func _player_behavoir(attack_type: int) -> void:	
	if attack_type == 0:
	
		for i in range(len(EnemyYokais)):
			if EnemyYokais[i].active and EnemyYokais[i].yokai_hp >= 0 and not EnemyYokais[i].inspirited:
				print("inspirit")
				global.on_yokai_action.emit(BattleYokaiHelper.PLAYER_TEAM, CurrentYokaiInst.yokai_number, i, "inspirit")
				return
	
	elif attack_type == 1 or attack_type == 2:
	
		#targeted
		for i in range(len(EnemyYokais)):
			if EnemyYokais[i].targeted and EnemyYokais[i].yokai_hp >= 0:
				global.on_yokai_action.emit(BattleYokaiHelper.PLAYER_TEAM, CurrentYokaiInst.yokai_number, i, "attack", attack_type)
				return
		
		#not targted
		for i in range(len(EnemyYokais)):
			if EnemyYokais[i].active and EnemyYokais[i].yokai_hp >= 0:
				print("attack")
				global.on_yokai_action.emit(BattleYokaiHelper.PLAYER_TEAM, CurrentYokaiInst.yokai_number, i, "attack", attack_type)
				return
