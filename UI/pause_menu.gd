class_name PauseMenu extends CanvasLayer

signal continue_pressed()

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func _input(_event: InputEvent) -> void:
	#if event.is_action_pressed("ui_cancel"):
		## If respawn is active, do nothing (shouldn't happen, but safety)
		#if PauseManager.respawn_active:
			#return
		#continue_pressed.emit()   # close the pause menu
	pass

func _ready() -> void:
	hide()
	#GameManager._PauseMenu = self
	pass

func _on_continue_pressed() -> void:
	audio_player.play()
	continue_pressed.emit()   # the main scene will close the menu

func _on_quit_pressed() -> void:
	audio_player.play()
	await get_tree().create_timer(0.2).timeout
	GameManager.quit_game()   # quit is internal to this scene
