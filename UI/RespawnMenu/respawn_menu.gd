class_name RespawnMenu extends Node

const MAIN_MENU = preload("uid://dt3w4y2xpbjde")

func _ready() -> void:
	GameManager._RespawnMenu = self
	self.visible = false

func _on_respawn_pressed() -> void:
	GameManager._player_respawn()

func _on_back_to_menu_pressed() -> void:
	GameManager.change_scene(MAIN_MENU)
	GameManager._update_leaderboard()

func _on_quit_pressed() -> void:
	GameManager.quit_game()
