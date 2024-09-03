class_name Ai extends Node


const INSPIRITING: int = 2
const ELEMENTAL_ATTACK: int = 1
const NORMAL_ATTACK: int = 0


var is_loafing: bool = false


@onready var BattleYokaiInstance: BattleYokai = get_parent().get_parent()


func behavoir_barrier() -> bool: 
	randomize()
	var random_float: float = randf()
	
	if random_float < 0.1  :
		return true
	return false


func action() -> int:
	randomize()
	var random_float: float = randf()
	
	if random_float < 0.05 :
		return INSPIRITING
	if random_float < 0.66:
		return NORMAL_ATTACK
	if random_float <= 1.0:
		return ELEMENTAL_ATTACK
	
	return -1


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
