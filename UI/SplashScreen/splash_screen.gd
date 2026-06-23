extends Control

const MAIN_MENU = preload("uid://dt3w4y2xpbjde")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)

func _on_video_stream_player_finished() -> void:
	animation_player.play("fade")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	GameManager.change_scene(MAIN_MENU)
