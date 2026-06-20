extends Control

@export var game_scene: PackedScene

func _on_play_button_pressed() -> void:
	if game_scene:
		get_tree().change_scene_to_packed(game_scene)
	else:
		print("Error: no game found")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
