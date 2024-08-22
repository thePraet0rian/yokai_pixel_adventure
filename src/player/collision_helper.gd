class_name CollisionHelper extends Node2D


signal can_action_space


var NpcInstance: Npc
var OverworldYokaiInstance: OverworldYokai
var YokaiSpotInstance: YokaiSpot
var SpotColliderInstance: SpotCollider

var npc_met: bool = false
var yokai_met: bool = false
var can_transition: bool = false
var is_tracking_hotspot: bool = false
var can_start_battle: bool = false
var can_use_eyepo: bool = false
var can_open_spot: bool = false

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
		if can_open_spot:
			_spot()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	match area.name:	
		"npc_hurtbox":
			NpcInstance = area.get_parent()
			npc_met = true
			can_action_space.emit(true)
		
		"yokai":
			OverworldYokaiInstance = area.get_parent()
			yokai_met = true
			can_action_space.emit(true)
			
		"transition":
			can_transition = true
			transition_target = area.connected_transition_area
			can_action_space.emit(true)
		
		"yokai_hotspot":
			is_tracking_hotspot = true
			YokaiSpotInstance = area
			set_process(true)
			can_action_space.emit(true)
		
		"yokai_hitbox":
			can_use_eyepo = true
			can_action_space.emit(true)
		
		"spot_hitbox":
			can_open_spot = true
			SpotColliderInstance = area
			can_action_space.emit(true)


func _on_hurtbox_area_exited(area: Area2D) -> void:
	match area.name:
		"npc_hurtbox":
			npc_met = false
			can_action_space.emit(false)
		
		"yokai":
			yokai_met = false
			can_action_space.emit(false)
		
		"yokai_hotspot":
			is_tracking_hotspot = false
			set_process(false)
			can_action_space.emit(false)
		
		"yokai_hitbox":
			can_use_eyepo = false
			can_action_space.emit(false)
		
		"spot_hitbox":
			can_open_spot = false
			can_action_space.emit(false)


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
		
		4:
			GlobalQuests.quest_interaction.emit(NpcInstance.current_quest)
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


func _spot() -> void:
	global.on_spot_started.emit(SpotColliderInstance.current_yokais, SpotColliderInstance.has_yokai, SpotColliderInstance.current_spot)
	can_open_spot = false
	get_tree().paused = true


func _process(_delta: float) -> void:
	if is_tracking_hotspot:
		var distance: float = int(get_parent().position.distance_to(YokaiSpotInstance.position))
		if distance < 5:
			can_start_battle = true
			
