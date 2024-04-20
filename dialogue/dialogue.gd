class_name Dialogue
extends CanvasLayer


@onready var text_label: RichTextLabel = $text


var writing: bool = false

var test = preload("res://dialogue/dialogue.Hello, Bob!.translation")

func get_dialogue() -> void:
	
	print(test.get_as_text())


func _ready() -> void:
	
	write_text()


func write_text() -> void: 
	
	text_label.visible_ratio = 0
	writing = true
	create_tween().tween_property(text_label, "visible_ratio", 1, 1)


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("space"):
		if writing:
			write_text()
