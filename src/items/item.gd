class_name Item extends Node


var item_name: String = ""
var item_count: int = 1
var item_texture: Texture = preload("res://res/items/items.png")
var item_description: String = "This is an item."

var item_buy_price: int = 0


func _init(ite_name: String) -> void:
	
	self.item_name = ite_name
