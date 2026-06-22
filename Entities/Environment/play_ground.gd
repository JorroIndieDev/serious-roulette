extends Node2D


@onready var gambling_ui: CanvasLayer = $GamblingUI
@onready var hud: CanvasLayer = $HUD
@onready var gambling: GamblingNode = $GamblingUI/Gambling


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		PlayerData.leveled_up = true
		#PlayerData._append_upgrade(
			#UpgradeDB.available_upgrades[Upgrade.ID.BULLETDMGUP]
			#)
		#print_debug(PlayerData.upgrades_list)


func _ready() -> void:
	gambling_ui.visible = false
	hud.visible = true
	
	gambling.connect("finished_gambling", _back_from_gambling)
	PlayerData.connect("_player_leveled", _level_up_reward)


func _level_up_reward() -> void:
	get_tree().paused = true
	gambling_ui.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _back_from_gambling() -> void:
	get_tree().paused = false
	gambling_ui.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
