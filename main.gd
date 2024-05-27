class_name Main extends Node2D


func _ready() -> void:
	
	global._on_battle_start.connect(_on_battle_started)
	global._on_battle_end.connect(_on_battle_end)
	
	global._on_room_transition.connect(_on_room_transition)
	
	global._on_warp.connect(_on_warp)
	global._on_save.connect(_on_save)
	global._on_load.connect(_on_load)
	
	global._on_dialogue.connect(_on_dialogue)
	global._on_dialogue_end.connect(_on_dialogue_end)
	global._on_menue_close.connect(_on_menue_close)


const BattleScene: PackedScene = preload("res://battle/battle.tscn")


func _on_battle_started(enemy_yokai_arr: Array[Yokai]) -> void:
	
	var BattleInstance: Battle = BattleScene.instantiate()	
	BattleInstance.player_yokai_arr = global.player_yokai
	BattleInstance.enemy_yokai_arr = enemy_yokai_arr.duplicate()
	add_child(BattleInstance)


func _on_battle_end() -> void:
	
	_on_menue_close()


func _on_room_transition(room: int) -> void:
	
	match room:		
		1:
			$rooms/room_01.queue_free()
			$rooms.add_child(global.rooms[0].instantiate())


func _on_warp(warp: int) -> void:
	
	match warp: 
		0:
			pass


const save_file_arr: Array[String] = [
	"user://savefile_one.save", 
	"user://savefile_two.save", 
	"user://savefile_three.save"
]

var save_file_int: int 


func _on_load(_save_file: int) -> void:
	
	#save_file_int = _save_file
	
	#var load_file = FileAccess.open(save_file_arr[save_file_int], FileAccess.READ)
	#var _inventory_length: int = load_file.get_8()
	
	#for i in range(3):
		#pass
	
	#load_file.close()
	pass


func _on_save() -> void:
	
	var save_file = FileAccess.open(save_file_arr[save_file_int], FileAccess.WRITE)
	
	save_file.store_8(3)
	
	for i in range(len(global.player_inventory)):
		save_file.store_var(global.player_inventory[i][0].name_str)
		save_file.store_var(global.player_inventory[i][0].description)
		save_file.store_var(global.player_inventory[i][0].sprite)
	
	save_file.close()


const dialogue_scn: PackedScene = preload("res://dialogue/dialogue.tscn")


func _on_dialogue(npc_name: String, dialogue_int: int) -> void:
	
	var DialogueInstance: Dialogue = dialogue_scn.instantiate()
	DialogueInstance.get_dialogue(npc_name, str(dialogue_int))
	add_child(DialogueInstance)


func _on_dialogue_end() -> void:
	
	get_tree().paused = false


@onready var ui_anim_player: AnimationPlayer = $ui/anim_player
@onready var ui_overlay: ColorRect = $ui/ColorRect


func _on_menue_close() -> void:
	
	ui_overlay.visible = true
	ui_anim_player.play("fade_in")
	
	await ui_anim_player.animation_finished
	ui_overlay.visible = false
	
	ui_anim_player.play("RESET")


func _on_main_timer_timeout() -> void:
	global.current_time += 1
