class_name RespawnMenu extends CanvasLayer

const MAIN_MENU = preload("uid://dt3w4y2xpbjde")
@export var cost_to_respawn: int
signal respawn_pressed()

func _ready() -> void:
	GameManager._RespawnMenu = self
	self.visible = false

func _on_respawn_pressed() -> void:
	if PlayerData.player_coins < cost_to_respawn: return
	
	PlayerData._player_coins = PlayerData._player_coins - cost_to_respawn
	PlayerData.emit_signal("coins_gained",PlayerData._player_coins)

	GameManager._player_respawn()
	#GameManager._PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	respawn_pressed.emit()
	#self.visible = false

func _on_back_to_menu_pressed() -> void:
	GameManager.change_scene(MAIN_MENU)

func _on_quit_pressed() -> void:
	GameManager.quit_game()
