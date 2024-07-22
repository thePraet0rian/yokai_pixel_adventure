class_name OverworldYokai extends StaticBody2D


enum BEHAVOIRS {
	STANDING = 0, 
	ATTACKING = 1,
}

@export var yokai_name: String = ""
@export var behavoir: BEHAVOIRS = BEHAVOIRS.STANDING

@onready var sprite: Sprite2D = $sprite


func _ready() -> void:
	
	match yokai_name:
		
		"Mirapo":
			sprite.texture = load("res://res/yokai/mirapo/miarpo.png")
		"Jibanyan":
			sprite.texture = load("res://res/yokai/jibanyan/jibanyan_one.png")
		"Darkyubi":
			sprite.texture = load("res://res/yokai/darkyubi/darkyubi.png")
		"Eyepo":
			sprite.texture = load("res://res/yokai/eyepo/eyepo_two.png")
			sprite.hframes = 2
		_:
			print("YOKAI NAME NOT FOUND")


func _on_yokai_area_entered(_area: Area2D) -> void:
	if yokai_name == "Eyepo":
		sprite.frame = 1

func _on_yokai_area_exited(_area: Area2D) -> void:
	if yokai_name == "Eyepo":
		sprite.frame = 0
