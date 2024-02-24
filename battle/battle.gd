class_name battle
extends CanvasLayer


enum player_states {}


###############################################################################


@onready var ui_anim_player: AnimationPlayer = $ui/ui_anim_player


func _ready() -> void:
	
	print("wasdf")
	setup_battle()


func setup_battle() -> void:
	
	pass


###############################################################################


func _input(event: InputEvent) -> void:
	
	if inventory_entered:
		if event.is_action_pressed("left"):
			pass


var inventory_entered: bool = false


func _on_area_2d_mouse_entered() -> void:
	inventory_entered = true
	print("yes")


###############################################################################
