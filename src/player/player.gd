# --------------------------------------------------------------------------------------------------
## GLOBAL PLAYER CLASS 
class_name Player extends CharacterBody2D


const DEBUG_SCENE: PackedScene = preload("res://src/player/debug.tscn")
const INVENTORY_SCENE: PackedScene = preload("res://src/player/inventory.tscn")
const MAP_SCENE: PackedScene = preload("res://src/ui/map/map.tscn")


@onready var CollisionHelper: Node = $collision_helper



@onready var Hurtbox: Area2D = $collision_helper/hurtbox
@onready var UiAnimPlayer: AnimationPlayer = $ui/player_ui/ui_anim_player
@onready var SprintBar: Sprite2D = $ui/sprint_bar
#@onready var sprint_timer: Timer = $sprint_bar/sprint_timer
#



@onready var AnimPlayer: AnimationPlayer = $anim_player
@onready var AnimTree: AnimationTree = $anim_tree
@onready var anim_propteries = $anim_tree.get("parameters/playback")

#@onready var confirm_button: Sprite2D = $accept_button

var input_vec: Vector2 = Vector2.ZERO
var speed: int = 70
var is_moving: bool = false
var state_change: bool = false
var previous_input_vec: Vector2 = Vector2.ZERO
var is_hidden: bool = false
var can_sprint: bool = true
var is_sprinting: bool = false

var can_transition: bool = false
var transition_target: int = 0

var hotspot_target: Area2D
var is_tracking_hostop: bool

var NpcInstance: Npc
var npc_met: bool = false
var npc_type: int = 0

var YokaiInstance: OverworldYokai
var yokai_met: bool = false


# METHODS # ----------------------------------------------------------------------------------------
# Private:


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("esc"): 
		get_parent().add_child(DEBUG_SCENE.instantiate())
		get_tree().paused = true
		
	if event.is_action_pressed("inventory"):
		get_tree().paused = true
		get_parent().add_child(INVENTORY_SCENE.instantiate())
	
	if event.is_action_pressed("map"):
		get_parent().add_child(MAP_SCENE.instantiate())
		get_tree().paused = true


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
				SprintBar.visible = true
	else:
		speed = 70
		SprintBar.visible = false


func move() -> void:
	
	previous_input_vec = input_vec
	
	input_vec.x = Input.get_axis("move_left", "move_right")
	input_vec.y = Input.get_axis("move_up", "move_down")
	
	if previous_input_vec == Vector2.ZERO and input_vec != Vector2.ZERO:
		
		if input_vec != Vector2.ZERO:
			if not is_hidden:
				UiAnimPlayer.play("hide_objective")
				is_hidden = true
	
	if previous_input_vec != Vector2.ZERO and input_vec == Vector2.ZERO:
		show_objective()
	 
	if input_vec == Vector2.LEFT:
		Hurtbox.position = Vector2(-9, -4)
	elif input_vec == Vector2.RIGHT:
		Hurtbox.position = Vector2(9, -4)
	elif input_vec == Vector2.DOWN:
		Hurtbox.position = Vector2.ZERO
	elif input_vec == Vector2.UP:
		Hurtbox.position = Vector2(0, -8)
	
	_animate()
	
	velocity = input_vec.normalized() * speed
	move_and_slide()


func hotspot_tracking() -> void:
	
	print(position.distance_to(hotspot_target.position))


func _animate() -> void:
	
	if input_vec != Vector2.ZERO:
		
		AnimTree.set("parameters/idle/blend_position", input_vec)
		AnimTree.set("parameters/run/blend_position", input_vec)
		
		anim_propteries.travel("run")
	else:         
		anim_propteries.travel("idle")


func show_objective() -> void:
	
	await get_tree().create_timer(2).timeout
	
	if input_vec == Vector2.ZERO:
		if is_hidden:
			UiAnimPlayer.play("show_objective")
			is_hidden = false


# Public:


func set_orientation(new_orientation: Vector2) -> void:
	
	input_vec = new_orientation
	_animate()


# --------------------------------------------------------------------------------------------------
