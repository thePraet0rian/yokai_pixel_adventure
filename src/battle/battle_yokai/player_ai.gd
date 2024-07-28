class_name PlayerAi extends Ai


signal player_animation

var enemy_arr: Array = []
var enemy_health_arr: PackedInt32Array = []


func set_enemys(enemy_arr: Array[BattleYokai]) -> void:
	self.enemy_arr = enemy_arr
	for i in range(3):
		enemy_health_arr.append(enemy_arr[i].YokaiInst.yokai_hp)
	print("health arr")
	print(enemy_health_arr)


func player_tick() -> void:
	if behavoir_barrier():
		_player_grouchy_behavoir()


func _player_grouchy_behavoir() -> void:
	for i in range(len(enemy_arr)):
		if enemy_health_arr[i] >= 0:
			global.on_yokai_action.emit(0, i, "attack")
			
			await global.on_yokai_return_action
			player_animation.emit()
			return
