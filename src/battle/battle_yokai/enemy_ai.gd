class_name EnemyAi extends Ai


func enemy_tick() -> void:
	if behavoir_barrier():
		_enemy_grouchy_behavoir()


func _enemy_grouchy_behavoir() -> void:
	BattleYokaiInstance.AnimPlayer.play("flash")
	global.on_yokai_action.emit(1, 0, "attack")
