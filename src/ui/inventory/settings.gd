# --------------------------------------------------------------------------------------------------
extends Node2D


@onready var Parent: Inventory = get_parent().get_parent()


# METHODS # ----------------------------------------------------------------------------------------


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shift"):
		await get_tree().physics_frame
		Parent.current_state = Parent.STATES.MAIN
		queue_free()
		
		
# --------------------------------------------------------------------------------------------------
