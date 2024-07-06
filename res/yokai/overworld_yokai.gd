# --------------------------------------------------------------------------------------------------
## GLOBAL OVERWORLD CLASS
class_name OverworldYokai extends StaticBody2D


enum BEHAVOIRS {STANDING = 0, ATTACKING = 1}


@export var yokai_name: String = ""
@export var behavoir: BEHAVOIRS = BEHAVOIRS.STANDING

@onready var sprite: Sprite2D = $sprite


# METHODS # ----------------------------------------------------------------------------------------
# Private: 

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
		_:
			print("YOKAI NAME NOT FOUND")


# --------------------------------------------------------------------------------------------------
