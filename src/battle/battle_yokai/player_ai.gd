class_name PlayerAi extends Ai



func player_tick() -> void:
	if behavoir_barrier():
		match action():
			INSPIRITING:
				_player_behavoir(INSPIRITING)
			ELEMENTAL_ATTACK:
				_player_behavoir(ELEMENTAL_ATTACK)
			NORMAL_ATTACK:
				_player_behavoir(NORMAL_ATTACK)


func _player_behavoir(attack_type: int) -> void:	
	match attack_type:
		INSPIRITING:
			for i in OpponentYokais.size():
				if OpponentYokais[i].active and not OpponentYokais[i].inspirited:
					global.on_yokai_action.emit("inspirit", 0, CurrentYokaiInst.yokai_number, i, [attack_type])
					return

		NORMAL_ATTACK:
			for i in OpponentYokais.size():
				if OpponentYokais[i].active:
					global.on_yokai_action.emit("attack", 0, CurrentYokaiInst.yokai_number, i, [attack_type])
					return
	
		ELEMENTAL_ATTACK:
			for i in OpponentYokais.size():
				if OpponentYokais[i].active:
					global.on_yokai_action.emit("attack", 0, CurrentYokaiInst.yokai_number, i, [attack_type])
					return 
