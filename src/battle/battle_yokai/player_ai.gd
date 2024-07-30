class_name PlayerAi extends Ai


signal player_animation

var enemy_ai_arr: PackedInt32Array = []


func set_enemys(enemy_arr: Array[BattleYokai]) -> void:
	for i in range(len(enemy_arr)):
		if enemy_arr[i] != null:
			enemy_ai_arr.append(enemy_arr[i].YokaiInst.yokai_hp)
		else:
			enemy_ai_arr.append(0)


func player_tick() -> void:
	if behavoir_barrier():
		_player_grouchy_behavoir()


func _player_grouchy_behavoir() -> void:
	for i in range(len(enemy_ai_arr)):
		if enemy_ai_arr[i] >= 0:
			global.on_yokai_action.emit(0, i, "attack")
			
			await global.on_yokai_return_action
			player_animation.emit()
			return
