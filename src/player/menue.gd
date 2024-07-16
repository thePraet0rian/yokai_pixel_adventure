# --------------------------------------------------------------------------------------------------
## GLOBAL INVENTORY CLASS 
class_name Inventory extends CanvasLayer


const INVENTORY_SCENE: PackedScene = preload("res://scn/menue/inventory.tscn")
const SAVE_SCREEN_SCENE: PackedScene = preload("res://scn/ui/inventory/save_screen.tscn")
const TEAM_SCENE: PackedScene = preload("res://scn/ui/inventory/team.tscn")
const SETTINGS_SCENE: PackedScene = preload("res://scn/ui/inventory/settings.tscn")
const MEDALLS_SCENE: PackedScene = preload("res://scn/ui/inventory/medalls.tscn")


enum STATES {
	MAIN = 0, 
	INVENTORY = 1, 
	SAVE = 2, 
	MEDALLS = 3, 
	TEAM = 4,
	SETTINGS = 5
}


@onready var MoneyLabel: Label = $main/top_bar/money
@onready var AnimPlayer: AnimationPlayer = $main/anim_player
@onready var SubInventory: Node2D = $sub_ui

@onready var Buttons: Array[Array] = [
	[$main/buttons/button_0, $main/buttons/button_3], 
	[$main/buttons/button_1, $main/buttons/button_4], 
	[$main/buttons/button_2, $main/buttons/button_5], 
	[$main/buttons/button_06, $main/buttons/button_06],
]


var cur_pos: Vector2 = Vector2.ZERO
var current_state: STATES = STATES.MAIN


# Public Methods # ---------------------------------------------------------------------------------


func set_current_state(state: int) -> void:
	
	current_state = state as STATES


# Private # ----------------------------------------------------------------------------------------


func _ready() -> void:
	
	MoneyLabel.text = str(global.current_money)


func _input(event: InputEvent) -> void:
	
	match current_state:
		0:
			_main_menue_input(event)


func _main_menue_input(event: InputEvent) -> void:

	if event.is_action_pressed("move_up"):
		if cur_pos.y == 0:
			pass
		else:
			cur_pos.y -= 1
	if event.is_action_pressed("move_down"):

		if cur_pos.y == 1:
			pass
		else:
			cur_pos.y += 1
	if event.is_action_pressed("move_left"):		
		if cur_pos.x == 0:
			pass
		else:
			cur_pos.x -= 1
	if event.is_action_pressed("move_right"):
		if cur_pos.x == 3:
			pass
		else:
			cur_pos.x += 1
	
	if event.is_action_pressed("shift"):
		AnimPlayer.play("end")
	
	if event.is_action_pressed("space"):
		AnimPlayer.play("enter")
		await AnimPlayer.animation_finished
		
		AnimPlayer.play("hide")
		await AnimPlayer.animation_finished
		
		_match_main_input()
	
	for i in range(len(Buttons)):
		for j in range(len(Buttons[i])):
			
			if not(i == cur_pos.x and j == cur_pos.y):
				Buttons[i][j].frame = 0
	
	Buttons[cur_pos.x][cur_pos.y].frame = 1


func _match_main_input() -> void:
	
	if cur_pos.x == 0 and cur_pos.y == 0:
		
		var InventoryInst: Node2D = INVENTORY_SCENE.instantiate()
		InventoryInst.inventory_close.connect(set_current_state)
		
		SubInventory.add_child(InventoryInst)
		current_state = STATES.INVENTORY
	
	if cur_pos.x == 1 and cur_pos.y == 0:
		
		var SaveScreenInst: Node2D = SAVE_SCREEN_SCENE.instantiate()
		SaveScreenInst.save_screen_close.connect(set_current_state)
		
		SubInventory.add_child(SaveScreenInst)
		current_state = STATES.SAVE
	
	if cur_pos.x == 2 and cur_pos.y == 1:
		
		var SettingsInstance: Node2D = SETTINGS_SCENE.instantiate()
		
		SubInventory.add_child(SettingsInstance)
		current_state = STATES.SETTINGS
	
	if cur_pos.x == 2 and cur_pos.y == 0:
		
		var MedallsInstance: Node2D = MEDALLS_SCENE.instantiate()
		
		SubInventory.add_child(MedallsInstance)
		current_state = STATES.MEDALLS
	
	if cur_pos.x == 3:
		
		var TeamInst: Team = TEAM_SCENE.instantiate()
		TeamInst.team_close.connect(set_current_state)
		
		SubInventory.add_child(TeamInst)
		current_state = STATES.TEAM


func _end() -> void:	
	
	global.on_menue_closed.emit()
	get_tree().paused = false
	queue_free()


# -------------------------------------------------------------------------------------------------
