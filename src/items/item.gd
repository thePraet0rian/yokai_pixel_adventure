class_name Item extends Node


enum ITEM_TYPES {
	HEALING = 0,
	REVIVE = 1,
	SOUL = 2, 
	FLEE = 3, 
}

var item_name: String = ""
var item_count: int = 1
var item_description: String = "This is an item."
var item_type: ITEM_TYPES = ITEM_TYPES.HEALING

var item_texture: Texture = preload("res://res/items/items.png")
var item_big_texture: Texture

var item_buy_price: int = 0
var item_sell_price: int
var item_priority: int


func _init(_item_name: String) -> void:
	self.item_name = _item_name
	self.item_priority = global_item.items["Onigiri"]["Priority"]
