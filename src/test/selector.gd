extends Area2D


func _ready() -> void:
	
	set_physics_process(true)
	set_physics_process(true)
	set_physics_process_internal(true)



func _process(_delta: float) -> void:
	
	if has_overlapping_areas():
		pass
