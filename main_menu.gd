class_name MainMenu extends Control

@export var game_scene: PackedScene
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

@onready var play_button: TextureButton = $MarginContainer/VBoxContainer/play_button
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ap: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	GameManager.main_menu = self

func _on_play_button_pressed() -> void:
	GlobalAudio.get_node("UI_sounds").play()
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	GameManager.reset_game()
	GameManager.change_scene(game_scene, false)

func _on_quit_button_pressed() -> void:
	audio.play()
	await get_tree().create_timer(0.2).timeout
	GameManager.quit_game()

func _intro_anim() -> void:
	animation_player.play("fade")
