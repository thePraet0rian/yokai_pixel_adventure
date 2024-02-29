class_name battle
extends CanvasLayer


enum YOKAI_STATES {}


###############################################################################


@onready var ui_anim_player: AnimationPlayer = $ui/ui_anim_player


func _ready() -> void:
	
	print("wasdf")
	setup_battle()


func setup_battle() -> void:
	
	pass


###############################################################################


enum GAME_STATES {MENUE= 0, TARGET = 1, SOULIMATE = 2, ITEM = 3, PURIFY = 4, NONE = 5}
var current_game_state: GAME_STATES =  GAME_STATES.MENUE


func _input(event: InputEvent) -> void:
	
	match current_game_state:
		
		0:
			menue_input(event)
		1:
			target_input(event)
		2:
			soulimate_input(event)
		3:
			item_input(event)
		4:
			purify_input(event)


@onready var players: Node2D = $players


var is_moving: bool = false
var input_direction: Vector2 = Vector2.ZERO

func menue_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("left"):
		if item_button_entered: 
			current_game_state = GAME_STATES.ITEM
			
		elif target_button_entered:
			current_game_state = GAME_STATES.TARGET
			
		elif soulimate_button_entered:
			current_game_state = GAME_STATES.SOULIMATE
			
		elif purify_button_entered:
			current_game_state = GAME_STATES.PURIFY
	
	input_direction.x = Input.get_axis("move_left", "move_right")


var progress: float = 0.0
var last_position: Vector2 = Vector2(0, -12)


func _physics_process(delta: float) -> void:
	
	if input_direction != Vector2.ZERO:
		
		progress += .05
		players.position = last_position + Vector2(72, 0) * input_direction * progress
		
		if progress >= 1.0:
			print("as")

func target_input(event: InputEvent) -> void:
	
	print("target")


func soulimate_input(event: InputEvent) -> void:
	
	print("soulimate")


func item_input(event: InputEvent) -> void:
	
	print("input")


func purify_input(event: InputEvent) ->  void:
	
	print("purify")


###############################################################################

var item_button_entered: bool = false
var target_button_entered: bool = false
var soulimate_button_entered: bool = false
var purify_button_entered: bool = false


func _on_item_button_mouse_entered() -> void:
	item_button_entered = true


func _on_item_button_mouse_exited() -> void:
	item_button_entered = false


func _on_target_button_mouse_entered() -> void:
	target_button_entered = true


func _on_target_button_mouse_exited() -> void:
	target_button_entered = false


func _on_soulimate_button_mouse_entered() -> void:
	soulimate_button_entered = true


func _on_soulimate_button_mouse_exited() -> void:
	soulimate_button_entered = false


func _on_purify_button_mouse_entered() -> void:
	purify_button_entered = true


func _on_purify_button_mouse_exited() -> void:
	purify_button_entered = false
