class_name Dialogue extends CanvasLayer


@onready var text_label: RichTextLabel = $text
@onready var character_sprite: Sprite2D = $character
@onready var TweenInst: Tween

var writing: bool = false
var text: Array
var dialouge_line: int = 0
var speed: float = 1.0


func set_dialogue(npc_name: String, npc: String) -> void:
	text = global_npc.talking_npcs[npc_name][npc]
	

func _ready() -> void:
	write_text()


func write_text() -> void:
	if len(text) != dialouge_line:
		text_label.visible_ratio = 0
		text_label.text = text[dialouge_line]["text"]
		character_sprite.texture = load(global_npc.npc_expressions["NPC_01"]["Angry"])
		dialouge_line += 1
		writing = true
		TweenInst = create_tween()
		await TweenInst.tween_property(text_label, "visible_ratio", 1, speed).finished
		writing = false
	else:
		global.on_dialogue_ended.emit()
		queue_free()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space"):
		if not writing:
			write_text()


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("shift"):
		TweenInst.set_speed_scale(2.0)
	else:
		TweenInst.set_speed_scale(1)
		
