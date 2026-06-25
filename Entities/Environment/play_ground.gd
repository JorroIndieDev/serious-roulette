extends Node2D

@onready var gambling_ui: CanvasLayer = $GamblingUI
@onready var hud: CanvasLayer = $HUD
@onready var gambling: GamblingNode = $GamblingUI/Gambling
@onready var pause_menu: PauseMenu = $pause_menu
@onready var respawn_menu: RespawnMenu = $RespawnMenu
@onready var casino_maker: SlotMachineSpawner = $CasinoMaker
@onready var arrow_pointer: ArrowPointer = $ArrowPointer

var current_mach: SlotMachineOBJ
var player_camera: Camera2D

func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#PlayerData.leveled_up = true
	
	if event.is_action_pressed("ui_cancel"):
		if PauseManager.respawn_active:
			return
		# If nothing else is open, open pause menu
		if not pause_menu.visible and not gambling_ui.visible:
			open_pause_menu()

func _ready() -> void:
	gambling_ui.hide()
	hud.hide()
	
	gambling.connect("finished_gambling", _back_from_gambling)
	gambling.connect("esc_pressed", _on_gambling_esc_pressed)   # new connection
	PlayerData.connect("_player_leveled", _level_up_reward)
	pause_menu.connect("continue_pressed", _on_pause_menu_continue)
	respawn_menu.connect("respawn_pressed", close_respawn_menu)

func _level_up_reward() -> void:
	GameManager.SubUI_Opened = true
	PauseManager.add_pause_source()
	_pick_random_slot_machine()
	gambling_ui.show()

func _back_from_gambling() -> void:
	GameManager.SubUI_Opened = false
	gambling_ui.hide()
	PauseManager.remove_pause_source()

func open_pause_menu():
	PauseManager.toggle_pause_menu()
	pause_menu.show()
	if GameManager.SubUI_Opened:
		gambling_ui.process_mode = Node.PROCESS_MODE_DISABLED

func close_pause_menu():
	PauseManager.toggle_pause_menu()
	pause_menu.hide()
	if GameManager.SubUI_Opened:
		gambling_ui.process_mode = Node.PROCESS_MODE_ALWAYS

func open_respawn_menu():
	PauseManager.respawn_active = true
	pause_menu.process_mode = Node.PROCESS_MODE_DISABLED
	PauseManager.add_pause_source()       # pause the game
	respawn_menu.show()                   # or whatever your node name is
	pause_menu.hide()                     # hide pause menu if it was open

func close_respawn_menu():
	PauseManager.respawn_active = false
	pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	PauseManager.remove_pause_source()    # unpause if no other sources
	respawn_menu.hide()

func _on_pause_menu_continue() -> void:
	close_pause_menu()   # this calls PauseManager.toggle_pause_menu() and hides the node

func _on_pause_menu_quit() -> void:
	pass

func _on_gambling_esc_pressed():
	open_pause_menu()

func _pick_random_slot_machine() -> void:
	var mach: Node2D = casino_maker.get_children().pick_random() as Node2D
	if mach is SlotMachineOBJ:
		if current_mach:
			current_mach.stop_flicker()
		current_mach = mach
		current_mach.turn_on()
		current_mach.is_chosen = true
		arrow_pointer.set_target(current_mach)

func chosen_machine_visible(visible: bool) -> void:
	if visible:
		arrow_pointer.hide()
	else:
		arrow_pointer.show()













#EOF
