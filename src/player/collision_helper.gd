# --------------------------------------------------------------------------------------------------
class_name CollisionHelper extends Node2D


var NpcInstance: Npc
var OverworldYokaiInstance: OverworldYokai

var npc_met: bool
var yokai_met: bool
var can_transition: bool
var is_tracking_hotspot: bool

var npc_type: int 
var transition_target


# METHODS # ----------------------------------------------------------------------------------------


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("space"):
		
		print(npc_met)
		
		if npc_met:
			npc_type = NpcInstance.get_type()
			_npc()
		
		if yokai_met:
			_yokai()
		
		if can_transition:
			_transition()
		
		if is_tracking_hotspot:
			pass


func _on_hurtbox_area_entered(area: Area2D) -> void:
	
	match area.name:	
		"npc_hurtbox":
			NpcInstance = area.get_parent()
			npc_met = true
		
		"yokai":
			OverworldYokaiInstance = area.get_parent()
			yokai_met = true
			
		"transition":
			can_transition = true
			transition_target = area.connected_transition_area
		
		"hotspot":
			pass


func _on_hurtbox_area_exited(area: Area2D) -> void:
	
	match area.name:
		
		"npc_hurtbox":
			npc_met = false
		
		"yokai":
			yokai_met = false
		
		"hotspot":
			is_tracking_hotspot = false


func _npc() -> void:
	
	match npc_type:
		1:
			global.on_dialogue_started.emit(NpcInstance.npc_name, NpcInstance.npc_int)
			npc_met = false
			get_tree().paused = true 
		
		3:
			global.on_shopkeeper_met.emit(NpcInstance.npc_name)
			npc_met = false
			get_tree().paused = true


func _transition() ->  void:
	
	global.on_room_transitioned.emit(transition_target)


func _yokai() -> void:
	
	global.on_yokai.emit(OverworldYokaiInstance.yokai_name)


func _on_player_area_entered(_area: Area2D) -> void:
	pass # Replace with function body.


# --------------------------------------------------------------------------------------------------
