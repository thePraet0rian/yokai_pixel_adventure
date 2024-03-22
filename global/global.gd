extends Node


signal _on_battle_start()
signal _on_battle_end()


var player_yokai: Array[Yokai] = [Yokai.new(0, preload("res://yokai/jibanyan/jibanyan.png")), 
	Yokai.new(0, preload("res://yokai/zerberker/zerberker_back.png")), 
	Yokai.new(0, preload("res://yokai/dargon_lord/dargon_lord_back.png")), 
	Yokai.new(0, preload("res://yokai/cadin/cadin.png")), 
	Yokai.new(0, preload("res://yokai/peckpocket/peckpocket.png")),
	Yokai.new(0, preload("res://yokai/jibanyan/jibanyan_back.png"))]


class Yokai: 
	
	enum PERSONALITIES {a, b, c , d}
	
	var health: float = 0.0
	var speed: float = 0.0
	var personality: PERSONALITIES = PERSONALITIES.a
	
	var back_sprite: Resource
	var front_sprite: Resource
	
	func _init(_health: float, _front_sprite: Resource) -> void:
		
		health = _health
		front_sprite = _front_sprite
