extends Node


signal _on_battle_start()
signal _on_battle_end()


class Yokai: 
	
	enum PERSONALITIES {a, b, c , d}
	
	var health: float = 0.0
	var speed: float = 0.0
	var personality: PERSONALITIES = PERSONALITIES.a
	var sprite: Texture
	
	func _init(_health: float) -> void:
		
		health = _health

