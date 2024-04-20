extends Node


signal _on_battle_start()
signal _on_battle_end()

signal _on_room_changing()

signal _on_warp()

signal _on_save
signal _on_load()

signal _on_dialogue()


var current_time: int = 0


var player_yokai: Array[Yokai] = [Yokai.new(0, preload("res://yokai/jibanyan/jibanyan.png")), 
	Yokai.new(0, preload("res://yokai/zerberker/zerberker_back.png")), 
	Yokai.new(0, preload("res://yokai/dargon_lord/dargon_lord_back.png")), 
	Yokai.new(0, preload("res://yokai/cadin/cadin.png")), 
	Yokai.new(0, preload("res://yokai/peckpocket/peckpocket.png")),
	Yokai.new(0, preload("res://yokai/jibanyan/jibanyan_back.png"))]


var player_inventory: Array[Item] = [Item.new()]


class Yokai: 
	
	var name: String
	var level: int
	var xp: int
	var rank: String = ""
	var league: String = ""
	
	var hp: int
	var strength: int
	var spirit: int
	var defence: int
	var speed: int
	
	var front_sprite: Texture
	var back_sprite: Texture
	
	
	func _init(_hp: int, _front_sprite: Resource) -> void:
		
		hp = _hp
		front_sprite = _front_sprite


class Item: 
	
	var name_str: String = "Name"
	var description: String = "Descwiption"
	
	var sprite: Texture = load("res://yokai/zerberker/zerberker_back.png")
	
	func _init() -> void:
		
		pass
