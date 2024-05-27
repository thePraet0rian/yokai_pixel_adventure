extends Area2D


@export var connected_transition_area: int = 0
@export var sprite_texture: Texture

@export var hitbox_points: Array[Vector2] = [
	Vector2(-8, -8), 
	Vector2(8, -8), 
	Vector2(-8, 8), 
	Vector2(8, 8)
]

@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: CollisionPolygon2D = $hitbox


func _ready() -> void:
	
	hitbox.polygon = hitbox_points
