class_name YokaiSpot extends Area2D


func _on_area_entered(area: Area2D) -> void:
	if area.name == "hurtbox":
		print(position.distance_to(area.position))
