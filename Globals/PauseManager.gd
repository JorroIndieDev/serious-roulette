# PauseManager.gd
extends Node

var pause_count: int = 0
var pause_menu_visible: bool = false
var respawn_active: bool = false

signal pause_state_changed(paused: bool)

func add_pause_source():
	pause_count += 1
	update_pause_state()

func remove_pause_source():
	if pause_count > 0:
		pause_count -= 1
		update_pause_state()
	else:
		push_warning("Tried to remove pause source when none active")

func toggle_pause_menu():
	pause_menu_visible = !pause_menu_visible
	if pause_menu_visible:
		add_pause_source()
	else:
		remove_pause_source()

func update_pause_state():
	var should_pause = pause_count > 0
	get_tree().paused = should_pause
	Input.set_mouse_mode(
		Input.MOUSE_MODE_VISIBLE if should_pause else Input.MOUSE_MODE_CONFINED_HIDDEN
	)
	pause_state_changed.emit(should_pause)
