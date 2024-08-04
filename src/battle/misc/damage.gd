class_name Damage extends Label



func set_damage(_damage: int) -> void:
	text = str(_damage)
	
	var Tween1: Tween = create_tween()
	Tween1.tween_property(self, "modulate", Color8(255, 255, 255, 0), 2)
	
	var Tween2: Tween = create_tween()
	Tween2.tween_property(self, "position", position - Vector2(0, 32), 2)
	await Tween2.finished
	
	queue_free()
