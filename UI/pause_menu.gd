extends CanvasLayer

@onready var menu_ui: Control = $menu_UI
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	menu_ui.visible=false
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()
		
func toggle_pause():
	var is_paused = not get_tree().paused
	get_tree().paused = is_paused
	if is_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	menu_ui.visible = is_paused

func _on_continue_pressed() -> void:
	audio_player.play()
	toggle_pause()
	

func _on_quit_pressed() -> void:
	audio_player.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().quit()
