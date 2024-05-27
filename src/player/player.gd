class_name Player extends CharacterBody2D


const debug_scn: PackedScene = preload("res://src/player/debug.tscn")
const inventory_scn: PackedScene = preload("res://src/player/inventory.tscn")
const map_scn: PackedScene = preload("res://src/ui/map/map.tscn")

var input_vec: Vector2 = Vector2.ZERO
var speed: int = 70


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("esc"): 
		get_parent().add_child(debug_scn.instantiate())
		get_tree().paused = true
		
	if event.is_action_pressed("inventory"):
		get_tree().paused = true
		get_parent().add_child(inventory_scn.instantiate())
		
	if event.is_action_pressed("space"):
		if npc_met:
			npc_dialogue()
		elif can_transition:
			transition()
	
	if event.is_action_pressed("map"):
		get_parent().add_child(map_scn.instantiate())
		get_tree().paused = true


@onready var hurtbox: Area2D = $hurtbox
@onready var ui_anim_player: AnimationPlayer = $player_ui/ui_anim_player
@onready var sprint_bar: Sprite2D = $sprint_bar
@onready var sprint_timer: Timer = $sprint_bar/sprint_timer

var is_moving: bool = false
var state_change: bool = false
var previous_input_vec: Vector2 = Vector2.ZERO
var is_hidden: bool = false

var can_sprint: bool = true
var is_sprinting: bool = false


func _process(_delta: float) -> void:
	
	sprint()
	move()
	
	if is_tracking_hostop:
		hotspot_tracking()
	

func sprint() -> void:
	
	if Input.is_action_pressed("shift"):
		if can_sprint:
			is_sprinting = true
			speed = 200
			if input_vec != Vector2.ZERO:
				sprint_bar.visible = true
	else:
		speed = 70
		sprint_bar.visible = false


func move() -> void:
	
	previous_input_vec = input_vec
	
	input_vec.x = Input.get_axis("move_left", "move_right")
	input_vec.y = Input.get_axis("move_up", "move_down")
	
	if previous_input_vec == Vector2.ZERO and input_vec != Vector2.ZERO:
		
		if input_vec != Vector2.ZERO:
			if not is_hidden:
				ui_anim_player.play("hide_objective")
				is_hidden = true
	
	if previous_input_vec != Vector2.ZERO and input_vec == Vector2.ZERO:
		show_objective()
	 
	if input_vec == Vector2.LEFT:
		hurtbox.position = Vector2(-9, -4)
	elif input_vec == Vector2.RIGHT:
		hurtbox.position = Vector2(9, -4)
	elif input_vec == Vector2.DOWN:
		hurtbox.position = Vector2.ZERO
	elif input_vec == Vector2.UP:
		hurtbox.position = Vector2(0, -8)
	
	_animate()
	
	velocity = input_vec.normalized() * speed
	move_and_slide()


func hotspot_tracking() -> void:
	
	print(position.distance_to(hotspot_target.position))


@onready var anim_player: AnimationPlayer = $anim_player
@onready var anim_tree: AnimationTree = $anim_tree
@onready var anim_propteries = $anim_tree.get("parameters/playback")


func _animate() -> void:
	
	if input_vec != Vector2.ZERO:
		
		anim_tree.set("parameters/walk/blend_position", input_vec)
		anim_tree.set("parameters/idle/blend_position", input_vec)
		anim_tree.set("parameters/run/blend_position", input_vec)
		
		anim_propteries.travel("run")
	else:
		anim_propteries.travel("idle")


func show_objective() -> void:
	
	await get_tree().create_timer(2).timeout
	
	if input_vec == Vector2.ZERO:
		if is_hidden:
			ui_anim_player.play("show_objective")
			is_hidden = false


func npc_dialogue() -> void:
	
	global._on_dialogue.emit(npc.npc_name, npc.npc_int)
	npc_met = false
	get_tree().paused = true 


@onready var confirm_button: Sprite2D = $accept_button

var npc_met: bool = false
var npc: CharacterBody2D

var can_transition: bool = false
var transition_target: int = 0

var hotspot_target: Area2D
var is_tracking_hostop: bool

func _on_hurtbox_area_entered(area: Area2D) -> void:
	
	if "npc" in area.get_parent().name:
		npc = area.get_parent()
		npc_met = true
	
	if "transition" in area.name:
		can_transition = true
		transition_target = area.connected_transition_area
	
	if "hotspot" in area.name:
		print("hotspot")
		hotspot_target = area
		is_tracking_hostop = true 


func transition() -> void:
	
	global._on_room_transition.emit(transition_target)


func _on_hurtbox_area_exited(area: Area2D) -> void:
	
	print("hai")	
	
	if "npc" in area.get_parent().name:
		npc_met = false
	
	if "hotspot" in area.name:
		print("hotspot exit")
		is_tracking_hostop = false

