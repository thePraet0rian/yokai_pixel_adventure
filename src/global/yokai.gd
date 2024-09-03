class_name Yokai extends Node


enum BEHAVIORS {
	GROUCHY = 0, 
	ROUGH = 1, 
	LOGICAL = 2, 
	BRAINY = 3, 
	TWISTED = 4, 
	CRUEL = 5, 
	HELPFUL = 6, 
	DEVOTED = 7, 
	GENTLE = 8, 
	TENDER = 9, 
	CAREFUL = 10, 
	CALM = 11, 
}


enum LOAFING {
	SERIOUS = 0, 
	STIFF = 1, 
	CAREFREE = 2, 
	LOAFER = 3,
}


var yokai_level: int = 1
var yokai_total_exp: int = 0
var yokai_exp_to_level: int = 6
var yokai_rank: String = ""
var yokai_league: String = ""

var yokai_soul: float = 0.0
var yokai_name: String = ""
var yokai_hp: int = 0
var yokai_str: int = 0
var yokai_spr: int = 0
var yokai_def: int = 0
var yokai_spd: int = 0

var yokai_max_hp: int

var active: bool = true
var loafer: bool = true
var targeted: bool = false
var inspirited: bool = false
var ticking: bool = false

var front_sprite: Texture
var back_sprite: Texture
var yokai_medall_sprite: Texture

var yokai_behavior: BEHAVIORS = BEHAVIORS.GROUCHY
var yokai_loafing: LOAFING = LOAFING.SERIOUS

var yokai_number: int


func _init(_yokai_name: String) -> void:
	if _yokai_name == "na":
		active = false
		return
	else:
		yokai_name = _yokai_name
		yokai_hp = yokai_stats.data[_yokai_name][0]["BS_A_HP"]
		yokai_str = yokai_stats.data[_yokai_name][0]["BS_A_Str"]
		yokai_spr = yokai_stats.data[_yokai_name][0]["BS_A_Spr"]
		yokai_def = yokai_stats.data[_yokai_name][0]["BS_A_Def"]
		yokai_spd = yokai_stats.data[_yokai_name][0]["BS_A_Spd"]

		yokai_max_hp = yokai_hp

		front_sprite = global_yokai.YOKAI_FRONT_SPRITES[_yokai_name]


func check_health() -> bool:
	if yokai_hp <= 0:
		return true
	return false


func loafing_bound() -> float:
	match yokai_loafing:
		
		0:
			pass
		1:
			pass
		2:
			pass
		3:
			pass
	
	return 1.0


func set_soul(soul: float) -> void:
	if (soul + yokai_soul > 1.0):
		return
	else:
		yokai_soul += soul


func experience(exp: int) -> Array:
	var level: int = 0
	var difference: int = yokai_exp_to_level - exp
	
	while difference < 0:
		exp -= yokai_exp_to_level
		level += 1
		_level_up()
		yokai_total_exp += yokai_exp_to_level
		
		yokai_exp_to_level = _calc_new_xp_to_level()
		difference = yokai_exp_to_level - exp
	
	return [level, exp]


func _cubed(number: int) -> int:
	return (number * number * number)


func _level_up() -> void:
	pass


func _calc_new_xp_to_level() -> int: 
	return _cubed(yokai_level + 1)
