extends Sprite2D


const CROSSHAIR = preload("uid://diswjtyk33sqf")
const CROSSHAIR_SHOT = preload("uid://cuuxn4tsts2uk")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	self.texture = CROSSHAIR

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			self.texture = CROSSHAIR_SHOT
			await get_tree().create_timer(0.1).timeout
			self.texture = CROSSHAIR
