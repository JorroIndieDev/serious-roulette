extends Node

var ProjectileContainer: Node

var main_menu: MainMenu

func _ready() -> void:
	pass

func _play_button() -> void:
	change_scene(main_menu.game_scene)

func change_scene(scene: PackedScene) -> void:
	get_tree().change_scene_to_packed(scene)

func _player_leveled() -> void:
	PlayerData.leveled_up = false
	print("Player Leveled")
