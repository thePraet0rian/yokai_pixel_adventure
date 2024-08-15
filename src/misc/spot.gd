class_name SpotCollider extends Area2D


enum Spots {
	FISHING_SPOT,
	BUSH_SPOT, 
	CAR_SPOT, 
	TREE_SPOT,
	TRASH_SPOT,
}


@export var current_spot: Spots = Spots.TREE_SPOT


var has_yokai: bool = false
var current_yokais: Array[Yokai] = []


func _ready() -> void:
	_generate_stuff()


func _generate_stuff() -> void:
	randomize()
	var random_float: float = randf()
	
	if random_float < 0.2: 
		_generate_yokai()
	else:
		_generate_generall()
	
	
func _generate_yokai() -> void:
	has_yokai = true
	for i in range(3):
		current_yokais.append(Yokai.new("Jibanyan"))


func _generate_generall() -> void:
	match current_spot:
		
		Spots.TREE_SPOT:
			pass

