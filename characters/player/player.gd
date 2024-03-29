class_name Player
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
		
		get_tree().paused = false
		get_parent().add_child(inventory_scn.instantiate())
	
	if confirm_button.visible == true:
		
		if Input.is_action_just_pressed("space"):
			global._on_room_changing.emit(0)


@onready var hurtbox: Area2D = $hurtbox
@onready var ui_anim_player: AnimationPlayer = $player_ui/ui_anim_player 

var is_moving: bool = false
var state_change: bool = false
var previous_input_vec: Vector2 = Vector2.ZERO
var is_hidden: bool = false


func _process(_delta: float) -> void:
	
	if Input.is_action_pressed("shift"):
		speed = 120
	else:
		speed = 70
	
	previous_input_vec = input_vec
	
	input_vec.x = Input.get_axis("move_left", "move_right")
	input_vec.y = Input.get_axis("move_up", "move_down")
	
	if previous_input_vec == Vector2.ZERO and input_vec != Vector2.ZERO:
		
		if input_vec != Vector2.ZERO:
			ui_anim_player.play("hide_objective")
			is_hidden = true
	
	if previous_input_vec != Vector2.ZERO and input_vec == Vector2.ZERO:
		
		if input_vec == Vector2.ZERO:
			if is_hidden:
				ui_anim_player.play("show_objective")
				is_hidden = false
	
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


@onready var confirm_button: Sprite2D = $Sprite2D


func _on_hurtbox_area_entered(_area: Area2D) -> void:
	print("yes")
	confirm_button.visible = true


func _on_hurtbox_area_exited(_area: Area2D) -> void:
	print("exited")
	confirm_button.visible = false
