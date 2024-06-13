class_name Global extends Node


signal on_battle_started()
signal on_battle_ended()

signal on_room_transitioned()

signal on_game_saved()
signal on_game_loaded()

signal on_dialogue_started()
signal on_dialogue_ended()

signal on_menue_closed()

signal on_yokai_action() 

signal on_shopkeeper_met()


var current_time: int = 0
var current_money: int = 1240
var player_inventory: Array[Array] = [
	[Item.new()],
	[Item.new()],
	[Item.new()],
	[Item.new()],
	[Item.new()],
]

@onready var player_yokai: Array[Yokai] = [
	Yokai.new("Jibanyan", preload("res://res/yokai/jibanyan/jibanyan_two.png")), 
	Yokai.new("Zerberker", preload("res://res/yokai/zerberker/zerberker_back.png")), 
	Yokai.new("Dragon Lord", preload("res://res/yokai/dargon_lord/dargon_lord_back.png")), 
	Yokai.new("Cadin", preload("res://res/yokai/cadin/cadin.png")), 
	Yokai.new("Peckpocket", preload("res://res/yokai/peckpocket/peckpocket.png")),
	Yokai.new("Jibanyan", preload("res://res/yokai/jibanyan/jibanyan_back.png"))
]

const rooms: Array[PackedScene] = [
	preload("res://scn/rooms/room_01.tscn"),
	preload("res://scn/rooms/room_02.scn"),
]
