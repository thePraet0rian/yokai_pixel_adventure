class_name PlayerAi extends Ai


func player_tick() -> void:
	if behavoir_barrier():
		_player_grouchy_behavoir()


func _player_grouchy_behavoir() -> void:
	var enemy_arr: Array[int] = BattleYokaiInstance.YokaiHelperInstance.get_enemy_arr()
	
	for i in range(len(enemy_arr)):
		if enemy_arr[i] >= 0:
			global.on_yokai_action.emit(0, i, "attack")
			
			await global.on_yokai_return_action
			BattleYokaiInstance.AnimPlayer.play("flash")
			return
