class_name Global extends Node



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

signal on_yokai_action(_action: String, _team: int, _yokai_number: int)
signal on_yokai_action_finished

signal on_shopkeeper_met
signal on_test_start

signal disable_main

signal on_yokai

signal on_start_eyepo

signal on_spot_started

signal on_quest_started

signal on_open_chest

signal on_heal_yokai


const rooms: Array[PackedScene] = [
	preload("res://scn/rooms/room_01.tscn"),
	preload("res://scn/rooms/room_03.tscn")
]



var current_time: int = 0
var current_money: int = 1240
var current_room: int

var player_inventory: Array[Array]
var player_yokai: Array[Yokai]
