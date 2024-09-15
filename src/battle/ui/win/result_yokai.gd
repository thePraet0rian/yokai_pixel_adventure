extends Sprite2D


@onready var Medall: Sprite2D = $Medall
@onready var LevelLabel: Label = $LevelLabel
@onready var XpBar: ColorRect = $XpBar


var gained_xp: int
var yokai: int


func set_xp(_xp: int) -> void:
	gained_xp = _xp


func set_yokai(_yokai: int) -> void:
	yokai = _yokai
	
	var difference: float = global.player_yokai[_yokai]._calc_new_xp_to_level() - global.player_yokai[_yokai].yokai_exp_to_level
	XpBar.scale.x = difference / float(global.player_yokai[_yokai]._calc_new_xp_to_level()) 
	print(XpBar.scale.x)


func _start() -> void:
	var returnArr: Array = global.player_yokai[yokai].experience(gained_xp)
	LevelLabel.text = str(global.player_yokai[yokai].yokai_level)
	
	for i in range(returnArr[0]):
		await create_tween().tween_property(XpBar, "scale", Vector2(1, 1), .75).finished
		XpBar.scale = Vector2(0, 1)
	
	var testf: float = (float(returnArr[1]) / float (global.player_yokai[0]._calc_new_xp_to_level()))
	await  create_tween().tween_property(XpBar, "scale", Vector2(testf, 1), 0.5).finished
	
	print(XpBar.scale.x)
