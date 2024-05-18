class_name Global extends Node

#region Signals #####################################################################

signal _on_battle_start()
signal _on_battle_end()

signal _on_room_changing()

signal _on_warp()

signal _on_save
signal _on_load()

signal _on_dialogue()
signal _on_dialogue_end

signal _on_menue_close

signal _on_yokai_action()

#endregion

#region Variables ###################################################################

var current_time: int = 0
var current_money: int = 1240
var player_inventory: Array[Item] = [Item.new()]

@onready var player_yokai: Array[Yokai] = [
	Yokai.new("Jibanyan", preload("res://yokai/jibanyan/jibanyan.png")), 
	Yokai.new("Zerberker", preload("res://yokai/zerberker/zerberker_back.png")), 
	Yokai.new("Dragon Lord", preload("res://yokai/dargon_lord/dargon_lord_back.png")), 
	Yokai.new("Cadin", preload("res://yokai/cadin/cadin.png")), 
	Yokai.new("Peckpocket", preload("res://yokai/peckpocket/peckpocket.png")),
	Yokai.new("Jibanyan", preload("res://yokai/jibanyan/jibanyan_back.png"))
]


#region Classes #####################################################################

class Yokai: 
	
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
	var rank: String = ""
	
	var yokai_name: String
	var yokai_hp: int
	var yokai_str: int
	var yokai_spr: int
	var yokai_def: int
	var yokai_spd: int
	
	var loafer: bool = true
	
	var front_sprite: Texture
	var back_sprite: Texture
	
	var yokai_behavior: BEHAVIORS = BEHAVIORS.GROUCHY
	var yokai_loafing: LOAFING = LOAFING.SERIOUS
	
	
	func _init(name: String, _front_sprite: Resource) -> void:
		
		yokai_name = name
		yokai_hp = yokai_stats.data[name][0]["BS_A_HP"]
		yokai_str = yokai_stats.data[name][0]["BS_A_Str"]
		yokai_spr = yokai_stats.data[name][0]["BS_A_Spr"]
		yokai_def = yokai_stats.data[name][0]["BS_A_Def"]
		yokai_spd = yokai_stats.data[name][0]["BS_A_Spd"]
		
		front_sprite = _front_sprite
	
	
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


class Item: 
	
	var name_str: String = "Name"
	var description: String = "Descwiption"
	
	var sprite: Texture = load("res://yokai/zerberker/zerberker_back.png")
	
	func _init() -> void:
		pass

#endregion
