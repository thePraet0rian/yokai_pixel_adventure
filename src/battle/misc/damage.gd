class_name Damage extends Label


@onready var AnimPlayer: AnimationPlayer = $AnimationPlayer


func set_damage(_damage: int) -> void:
	text = str(_damage)
	var Tween1 = create_tween()
	Tween1.tween_property(self, "modulate", Color8(255, 255, 255, 0), 1)
	await Tween1.finished
	queue_free()
