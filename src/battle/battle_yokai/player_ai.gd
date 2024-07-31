class_name PlayerAi extends Ai


signal player_animation


var enemy_yokai_arr: Array[Yokai]


func set_enemys(enemy_arr: Array[BattleYokai]) -> void:
	for i in range(len(enemy_arr)):
		enemy_yokai_arr.append(enemy_arr[i].YokaiInst)


func player_tick() -> void:
	if behavoir_barrier():
		_player_grouchy_behavoir()


func _player_grouchy_behavoir() -> void:
	for i in range(len(enemy_yokai_arr)):
		if enemy_yokai_arr[i].active:
			if enemy_yokai_arr[i].yokai_hp >= 0:
				global.on_yokai_action.emit(0, i, "attack")
				
				await global.on_yokai_return_action
				player_animation.emit()
				return
