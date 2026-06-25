class_name RespawnMenu extends CanvasLayer

const MAIN_MENU = preload("uid://dt3w4y2xpbjde")

signal respawn_pressed()

func _ready() -> void:
	GameManager._RespawnMenu = self
	self.visible = false

func _on_respawn_pressed() -> void:
	GameManager._player_respawn()
	GameManager._PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	respawn_pressed.emit()
	#self.visible = false

func _on_back_to_menu_pressed() -> void:
	GameManager.change_scene(MAIN_MENU)
	GameManager._update_leaderboard()

func _on_quit_pressed() -> void:
	GameManager.quit_game()
