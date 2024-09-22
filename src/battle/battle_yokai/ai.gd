class_name Ai extends Node



const INSPIRITING: int = 2
const ELEMENTAL_ATTACK: int = 1
const NORMAL_ATTACK: int = 0


var is_loafing: bool = false

var CurrentYokaiInst: Yokai
var OpponentYokais: Array[Yokai] = [null, null, null]



func set_current_yokai(_crr_yokai: Yokai) -> void:
	self.CurrentYokaiInst = _crr_yokai


func set_opponents(_opponent_yokais: Array[BattleYokai]) -> void:
	for i in OpponentYokais.size():
		OpponentYokais[i] = _opponent_yokais[i].YokaiInst


func behavoir_barrier() -> bool: 
	randomize()
	var random_float: float = randf()
	
	if random_float < 0.2:
		return true
	return false


func action() -> int:
	randomize()
	var random_float: float = randf()
	
	if random_float < 0.025 :
		return INSPIRITING
	if random_float < 0.99:
		return NORMAL_ATTACK
	if random_float <= 1.0:
		return ELEMENTAL_ATTACK
	
	return -1
