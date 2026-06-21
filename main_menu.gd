class_name MainMenu extends Control

@export var game_scene: PackedScene

signal play_pressed

func _ready() -> void:
	GameManager.main_menu = self
	connect("play_pressed", GameManager._play_button)

func _on_play_button_pressed() -> void:
	emit_signal("play_pressed")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
