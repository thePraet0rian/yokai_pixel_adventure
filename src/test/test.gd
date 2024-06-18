class_name test extends CanvasLayer


func _ready() -> void:
	
	$Node2D.process_mode = Node.PROCESS_MODE_DISABLED
	print("yes")
	await get_tree().create_timer(1).timeout
	$Node2D.process_mode = Node.PROCESS_MODE_INHERIT
	print("yes")
