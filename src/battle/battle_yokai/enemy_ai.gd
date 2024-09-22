class_name EnemyAi extends Ai



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
	match attack_type:
		INSPIRITING:
			for i in OpponentYokais.size():
				if OpponentYokais[i].active and not OpponentYokais[i].inspirited:
					global.on_yokai_action.emit("inspirit", 1, CurrentYokaiInst.yokai_number, i, attack_type)
					return

		NORMAL_ATTACK:
			for i in OpponentYokais.size():
				if OpponentYokais[i].active:
					global.on_yokai_action.emit("attack", 1, CurrentYokaiInst.yokai_number, i, attack_type)
					return
	
		ELEMENTAL_ATTACK:
			for i in OpponentYokais.size():
				if OpponentYokais[i].active:
					global.on_yokai_action.emit("attack", 1, CurrentYokaiInst.yokai_number, i, attack_type)
					return 
