class_name Behavoir extends Node

@onready var parent: Battle = get_node("..")

@onready var player_yokai_arr: Array[global.Yokai] = parent.player_yokai_arr
@onready var enemy_yokai_arr: Array[global.Yokai] = parent.enemy_yokai_arr


func attack(team: String, index: int) -> void:
	
	var damage: int = calc_damage(player_yokai_arr[index].yokai_str)
	var defending_yokai: int = select_yokai()
	enemy_yokai_arr[defending_yokai].yokai_hp -= damage


func calc_damage(yokai_str: int) -> int: 
	
	return yokai_str


func select_yokai() -> int:
	
	var alive_enemys: int = len(enemy_yokai_arr)
	
	randomize()
	var random_int: int = randi_range(0, alive_enemys)
	
	return random_int


func behavoir(team: String) -> void:
	
	match team:
		
		"player":
			player_behavoir()
		"enemy":
			enemy_behavoir()


func player_behavoir() -> void:
	
	for i in range(0, 3):
		
		randomize()
		var random_float: float = randf()
		
		if player_yokai_arr[i].yokai_spd < random_float:
			
			match player_yokai_arr[i].yokai_behavior:
				
				0:
					player_attack()
				1:
					pass
				2:
					pass
				3:
					pass


func enemy_behavoir() -> void:
	pass


func player_attack() -> void:
	
	for i in range(0, 3):
		pass

