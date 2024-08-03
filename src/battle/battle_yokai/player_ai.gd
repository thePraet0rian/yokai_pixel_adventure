class_name PlayerAi extends Ai


signal player_animation


var CurrentYokaiInst: Yokai
var EnemyYokais: Array[Yokai]


func set_current_yokai(crr_yokai: Yokai) -> void:
	self.CurrentYokaiInst = crr_yokai


func set_enemys(enemy_arr: Array[BattleYokai]) -> void:
	for i in range(len(enemy_arr)):
		EnemyYokais.append(enemy_arr[i].YokaiInst)


func player_tick() -> void:
	if behavoir_barrier():
		_player_grouchy_behavoir()


func _player_grouchy_behavoir() -> void:
	for i in range(len(EnemyYokais)):
		if EnemyYokais[i].active and EnemyYokais[i].yokai_hp >= 0:
			
			print("attack enemy by: " + str(CurrentYokaiInst.yokai_number))
				
			global.on_yokai_action.emit(0, CurrentYokaiInst.yokai_number, i, "attack")
			player_animation.emit()
			return
