class_name MainMenu extends Control

@export var game_scene: PackedScene
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

@onready var play_button: TextureButton = $MarginContainer/VBoxContainer/play_button

signal play_pressed

func _ready() -> void:
	GameManager.main_menu = self
	connect("play_pressed", GameManager._play_button)

func _on_play_button_pressed() -> void:
	GlobalAudio.get_node("UI_sounds").play()
	emit_signal("play_pressed")

func _on_quit_button_pressed() -> void:
	audio.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()
	

func _intro_anim() -> void:
	pass
