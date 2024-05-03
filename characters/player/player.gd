class_name Player_
extends CharacterBody2D


var input_vec: Vector2 = Vector2.ZERO
var speed: int = 70


const debug_scn: PackedScene = preload("res://characters/player/debug.tscn")
const inventory_scn: PackedScene = preload("res://characters/player/inventory.tscn")


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
	
	#if confirm_button.visible == true:
		#
		#if Input.is_action_just_pressed("space"):
			##global._on_room_changing.emit(0)
			#pass



@onready var hurtbox: Area2D = $hurtbox
@onready var ui_anim_player: AnimationPlayer = $player_ui/ui_anim_player
@onready var sprint_bar: Sprite2D = $sprint_bar

var is_moving: bool = false
var state_change: bool = false
var previous_input_vec: Vector2 = Vector2.ZERO
var is_hidden: bool = false


func _process(_delta: float) -> void:
	
	if Input.is_action_pressed("shift"):
		speed = 200
		sprint_bar.visible = true
	else:
		speed = 70
		sprint_bar.visible = false
	
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
		hurtbox.rotation = PI/2
	elif input_vec == Vector2.RIGHT:
		hurtbox.rotation = -PI/2
	elif input_vec == Vector2.DOWN:
		hurtbox.rotation = 0
	elif input_vec == Vector2.UP:
		hurtbox.rotation = -PI
	
	velocity = input_vec.normalized() * speed
	move_and_slide()


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


func _on_hurtbox_area_entered(area: Area2D) -> void:
	
	if "npc" in area.get_parent().name:
		npc = area.get_parent()
		npc_met = true


func _on_hurtbox_area_exited(area: Area2D) -> void:
	
	if "npc" in area.get_parent().name:
		npc_met = false
