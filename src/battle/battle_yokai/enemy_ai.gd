class_name EnemyAi extends Ai


signal enemy_animation
signal a


var CurrentYokaiInst: Yokai
var PlayerYokais: Array[Yokai]


func set_current_yokai(crr_yokai: Yokai) -> void:
	self.CurrentYokaiInst = crr_yokai


func set_players(player_arr: Array[BattleYokai]) -> void:
	for i in range(len(player_arr)):
		PlayerYokais.append(player_arr[i].YokaiInst)


func enemy_tick() -> void:
	if behavoir_barrier():
		_enemy_grouchy_behavoir()


func _enemy_grouchy_behavoir() -> void:
	for i in range(len(PlayerYokais)):
		if PlayerYokais[i].active and PlayerYokais[i].yokai_hp >= 0:
			
			_play_animation()
			await a
			global.on_yokai_action.emit(1, CurrentYokaiInst.yokai_number, i, "attack")
			return


func _play_animation() -> void:
	a.emit()
	await global.on_enemy_return_action
	enemy_animation.emit()
	
