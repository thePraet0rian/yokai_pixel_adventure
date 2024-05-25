class_name Global extends Node

@warning_ignore("unused_signal")
signal _on_battle_start()
@warning_ignore("unused_signal")
signal _on_battle_end()
@warning_ignore("unused_signal")
signal _on_room_transition()
@warning_ignore("unused_signal")
signal _on_warp()
@warning_ignore("unused_signal")
signal _on_save
@warning_ignore("unused_signal")
signal _on_load()
@warning_ignore("unused_signal")
signal _on_dialogue()
@warning_ignore("unused_signal")
signal _on_dialogue_end
@warning_ignore("unused_signal")
signal _on_menue_close
@warning_ignore("unused_signal")
signal _on_yokai_action()


var current_time: int = 0
var current_money: int = 1240
var player_inventory: Array[Array] = [[],[],[],[],[]]


@onready var player_yokai: Array[Yokai] = [
	Yokai.new("Jibanyan", preload("res://yokai/jibanyan/jibanyan_two.png")), 
	Yokai.new("Zerberker", preload("res://yokai/zerberker/zerberker_back.png")), 
	Yokai.new("Dragon Lord", preload("res://yokai/dargon_lord/dargon_lord_back.png")), 
	Yokai.new("Cadin", preload("res://yokai/cadin/cadin.png")), 
	Yokai.new("Peckpocket", preload("res://yokai/peckpocket/peckpocket.png")),
	Yokai.new("Jibanyan", preload("res://yokai/jibanyan/jibanyan_back.png"))
]

const rooms: Array[PackedScene] = [
	preload("res://rooms/room_02.scn"),
]
