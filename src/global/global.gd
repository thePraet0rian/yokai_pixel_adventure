class_name Global extends Node


const rooms: Array[PackedScene] = [
	preload("res://scn/rooms/room_01.tscn"),
	preload("res://scn/rooms/room_02.scn"),
]


signal on_yokai_return_action

signal on_battle_started
signal on_battle_ended

signal on_room_transitioned

signal on_game_saved
signal on_game_loaded

signal on_dialogue_started
signal on_dialogue_ended

signal on_menue_closed

signal on_yokai_action 

signal on_shopkeeper_met
signal on_test_start

signal disable_main

signal on_yokai


@onready var player_yokai: Array[Yokai] = [
	Yokai.new("Jibanyan", preload("res://res/yokai/jibanyan/jibanyan_two.png"), load("res://res/yokai/jibanyan/jibanyan_medall.png")),
	Yokai.new("Zerberker", preload("res://res/yokai/zerberker/zerberker_back.png"), load("res://res/yokai/cadin/cadin_medall.png")), 
	Yokai.new("Dragon Lord", preload("res://res/yokai/dargon_lord/dargon_lord_back.png"), load("res://res/yokai/cadin/cadin_medall.png")), 
	Yokai.new("Cadin", preload("res://res/yokai/cadin/cadin.png"), load("res://res/yokai/cadin/cadin_medall.png")), 
	Yokai.new("Peckpocket", preload("res://res/yokai/peckpocket/peckpocket.png"), load("res://res/yokai/cadin/cadin_medall.png")),
	Yokai.new("Jibanyan", preload("res://res/yokai/jibanyan/jibanyan_back.png"), load("res://res/yokai/cadin/cadin_medall.png")),
]


var current_time: int = 0
var current_money: int = 1240
var current_room: int

var player_inventory: Array[Array]
