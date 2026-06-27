extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("skip"):
		PauseManager.remove_pause_source()
		self.queue_free()
