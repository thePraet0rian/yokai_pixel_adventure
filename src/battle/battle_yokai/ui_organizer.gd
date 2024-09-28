class_name UiOrganizer extends Node


const PLAYER: int = 0
const ENEMY: int = 1


var current_team: int = PLAYER
var YokaiInstance: Yokai


@onready var PlayerUi: Node2D = $PlayerUi
@onready var EnemyUi: Node2D = $EnemyUi

@onready var SoulimateSelector: Sprite2D = $PlayerUi/SoulimateSelector
@onready var TargetArrow: Sprite2D = $TargetArrow
@onready var HealthBar: ColorRect = $PlayerUi/Ui/HealthBar
@onready var EnemyHealthBar: ColorRect = $EnemyUi/Ui/HealthBar
@onready var SoulMeter: ColorRect = $PlayerUi/Ui/SoulMeter/Soul
@onready var InspiritEffect: Sprite2D = $InspiritEffect


func set_team(_team: int) -> void:
	current_team = _team


func set_yokai_instance(_YokaiInstance) -> void:
	YokaiInstance = _YokaiInstance


func set_targeted(_target: bool = true) -> void:
	match current_team:
		ENEMY:
			TargetArrow.visible = _target


func set_inspirited(_active: bool = true) -> void:
	InspiritEffect.visible = _active


func set_soulimate(_active: bool) -> void:
	SoulimateSelector.visible = _active
	SoulimateSelector.frame = 1 if _active else 0
	

func set_target() -> void:
	TargetArrow.visible = true
	await get_tree().create_timer(.5).timeout
	TargetArrow.visible = false


func set_health(_health: int) -> void:
	match current_team:
		PLAYER:
			HealthBar.scale.x = (float(YokaiInstance.yokai_hp) / float(YokaiInstance.yokai_max_hp))
		ENEMY: 
			EnemyHealthBar.scale.x = (float(YokaiInstance.yokai_hp) / float(YokaiInstance.yokai_max_hp))


func set_soul() -> void:
	SoulMeter.scale.y = -(YokaiInstance.yokai_soul / 1.0)


func update_health_bar() -> void:
	var TweenInst: Tween = create_tween()
	var updated_hp: float = float(YokaiInstance.yokai_hp) / float(YokaiInstance.yokai_max_hp)
	
	match current_team:
		0:
			TweenInst.tween_property(HealthBar, "scale", Vector2(updated_hp, 1), 0.5)
		1:
			TweenInst.tween_property(EnemyHealthBar, "scale", Vector2(updated_hp, 1), 0.5)
	
	await TweenInst.finished
	GlobalBattle.update.emit()


func _ready() -> void:
	match current_team:
		PLAYER:
			EnemyUi.visible = false
			PlayerUi.visible = true
		ENEMY: 
			PlayerUi.visible = false
			EnemyUi.visible = true
		
