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


var yokia_level: int
var yokai_xp: int
var yokai_rank: String = ""
var yokai_league: String = ""

var yokai_soul: float = 0.0
var yokai_name: String
var yokai_hp: int
var yokai_str: int
var yokai_spr: int
var yokai_def: int
var yokai_spd: int

var yokai_max_hp: int

var active: bool = true
var loafer: bool = true

var front_sprite: Texture
var back_sprite: Texture
var yokai_medall_sprite: Texture

var yokai_behavior: BEHAVIORS = BEHAVIORS.GROUCHY
var yokai_loafing: LOAFING = LOAFING.SERIOUS


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
