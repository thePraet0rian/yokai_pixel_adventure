class_name CollisionHelper extends Node2D


var NpcInstance: Npc
var OverworldYokaiInstance: OverworldYokai
var YokaiSpotInstance: YokaiSpot

var npc_met: bool
var yokai_met: bool
var can_transition: bool
var is_tracking_hotspot: bool
var can_start_battle: bool
var can_use_eyepo: bool = false

var npc_type: int 
var transition_target


func _ready() -> void:
	set_process(false)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space"):
		if npc_met:
			npc_type = NpcInstance.get_type()
			_npc()	
		if yokai_met:
			_yokai()
		if can_transition:
			_transition()
		if is_tracking_hotspot and can_start_battle:
			_battle()
		if can_use_eyepo:
			_eyepo()


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
		
		"yokai_hotspot":
			is_tracking_hotspot = true
			YokaiSpotInstance = area
			set_process(true)
		
		"yokai_hitbox":
			can_use_eyepo = true


func _on_hurtbox_area_exited(area: Area2D) -> void:
	match area.name:
		"npc_hurtbox":
			npc_met = false
		
		"yokai":
			yokai_met = false
		
		"yokai_hotspot":
			is_tracking_hotspot = false
			set_process(false)
		
		"yokai_hitbox":
			can_use_eyepo = false


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


func _battle() -> void:
	pass


func _eyepo() -> void:
	global.on_start_eyepo.emit()


func _process(_delta: float) -> void:
	if is_tracking_hotspot:
		var distance: float = int(get_parent().position.distance_to(YokaiSpotInstance.position))
		if distance < 5:
			can_start_battle = true
			

