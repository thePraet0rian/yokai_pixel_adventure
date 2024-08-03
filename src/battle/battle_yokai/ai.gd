class_name Ai extends Node


@onready var BattleYokaiInstance: BattleYokai = get_parent().get_parent()


var is_loafing: bool = false


func _ready() -> void:
	global.on_enemy_return_action.connect(_test)


func _test() -> void:
	print("on enemy return action")


func behavoir_barrier() -> bool: 
	randomize()
	var random_float: float = randf()
	
	if random_float < 0.2:
		return true
	return false


func loaf() -> bool:
	if is_loafing:
		randomize()
		var random_float: float = randf()
		
		if random_float < 0.5:
			is_loafing = false
			return false
		else:
			return true
	else:
		randomize()
		var random_float: float = randf()
		
		if random_float < BattleYokaiInstance.YokaiInst.loafing_bound():
			is_loafing = false
			return false
		else:
			is_loafing = true
			return true
