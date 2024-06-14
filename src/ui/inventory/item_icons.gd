class_name ItemIcons extends Sprite2D


var item: Item

@onready var count: RichTextLabel = $RichTextLabel


func _ready() -> void:
	
	texture = item.item_texture
	count.text = str(item.item_count)
	
	match item.item_name:
		"Onigiri":
			frame = 0
		"Mighty Medicine": 
			frame = 11
