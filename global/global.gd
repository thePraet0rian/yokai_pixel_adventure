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
#endregion

#region Variables ###################################################################

var current_time: int = 0
var current_money: int = 1240
var player_inventory: Array[Item] = [Item.new()]

var player_yokai: Array[Yokai] = [Yokai.new(0, preload("res://yokai/jibanyan/jibanyan.png")), 
	Yokai.new(0, preload("res://yokai/zerberker/zerberker_back.png")), 
	Yokai.new(0, preload("res://yokai/dargon_lord/dargon_lord_back.png")), 
	Yokai.new(0, preload("res://yokai/cadin/cadin.png")), 
	Yokai.new(0, preload("res://yokai/peckpocket/peckpocket.png")),
	Yokai.new(0, preload("res://yokai/jibanyan/jibanyan_back.png"))]

#endregion

#region Classes #####################################################################

class Yokai: 
	
	enum BEHAVIORS {SERIOUS = 0, ROUGH = 1, GROUCHY = 2, HELPFUL = 3}
	
	var yokai_name: String
	var yokia_level: int
	var yokai_xp: int
	var rank: String = ""
	
	var yokai_hp: int
	var yokai_str: int
	var yokai_spr: int
	var yokai_def: int
	var yokai_spd: int
	
	var loafer: bool = true
	
	var front_sprite: Texture
	var back_sprite: Texture
	
	var behavior: BEHAVIORS = BEHAVIORS.GROUCHY
	
	func _init(_hp: int, _front_sprite: Resource) -> void:
		
		yokai_hp = _hp
		front_sprite = _front_sprite


class Item: 
	
	var name_str: String = "Name"
	var description: String = "Descwiption"
	
	var sprite: Texture = load("res://yokai/zerberker/zerberker_back.png")
	
	func _init() -> void:
		
		pass

#endregion
