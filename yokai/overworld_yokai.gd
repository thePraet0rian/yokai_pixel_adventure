extends StaticBody2D


@export var yokai_name: String = ""

@onready var sprite: Sprite2D = $sprite


func _ready() -> void:
	
	match yokai_name:
		
		"Mirapo":
			sprite.texture = load("res://yokai/mirapo/overworld_mirapo.png")
		
		_:
			
			print("YOKAI NAME NOT FOUND")
			return
