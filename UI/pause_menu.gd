extends CanvasLayer

@onready var menu_ui: Control = $menu_UI

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
	toggle_pause()


func _on_quit_pressed() -> void:
	get_tree().quit()
