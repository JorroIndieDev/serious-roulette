extends Node2D

@onready var crosshair_normal: Sprite2D = $CrosshairNormal
@onready var crosshair_shoot: Sprite2D = $CrosshairShoot

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	crosshair_normal.visible = true
	crosshair_shoot.visible = false

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			crosshair_normal.visible = false
			crosshair_shoot.visible = true
			await get_tree().create_timer(0.1).timeout
			crosshair_normal.visible = true
			crosshair_shoot.visible = false
