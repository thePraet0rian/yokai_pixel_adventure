class_name EnemyAi extends Ai


signal enemy_animation


func set_enemys(opponents: Array[BattleYokai]) -> void:
	pass


func enemy_tick() -> void:
	if behavoir_barrier():
		_enemy_grouchy_behavoir()


func _enemy_grouchy_behavoir() -> void:
	enemy_animation.emit()
	global.on_yokai_action.emit(1, 0, "attack")
