class_name Global extends Node


const rooms: Array[PackedScene] = [
	preload("res://scn/rooms/room_01.tscn"),
	preload("res://scn/rooms/room_02.scn"),
]


signal on_player_return_action
signal on_enemy_return_action

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


var current_time: int = 0
var current_money: int = 1240
var current_room: int

var player_inventory: Array[Array]
var player_yokai: Array[Yokai]
