class_name Dialogue
extends CanvasLayer


@onready var text_label: RichTextLabel = $text


var writing: bool = false
var text: Array
var dialouge_line: int = 0


func get_dialogue(npc_name: String, npc: String) -> void:
	
	var file = FileAccess.open("res://dialogue/test.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	text = data[npc_name][npc]
	file.close()
	

func _ready() -> void:
	
	write_text()


func write_text() -> void: 
	
	if len(text) != dialouge_line:
		text_label.visible_ratio = 0
		text_label.text = text[dialouge_line]["text"]
		dialouge_line += 1
		writing = true
		await create_tween().tween_property(text_label, "visible_ratio", 1, 1).finished
		writing = false
	else:
		global._on_dialogue_end.emit()
		queue_free()


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("space"):
		if not writing:
			write_text()
