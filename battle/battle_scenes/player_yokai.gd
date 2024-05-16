class_name PlayerYokai extends Sprite2D


func _ready() -> void:
	
	pass




@onready var sprite: Sprite2D = $Sprite2D


func update_sprite(updated_texture: Texture) -> void:
	sprite.texture = updated_texture
