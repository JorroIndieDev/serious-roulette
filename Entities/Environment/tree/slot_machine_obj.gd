class_name SlotMachineOBJ extends StaticBody2D

@export var min_energy : float = 0.6
@export var max_energy : float = 1.0
@export var flicker_speed : float = 60.0   # base frequency (Hz)
@export var cost: int

# For colour shifts
@export var min_temperature : float = 0.9   # 1.0 = neutral, lower = warmer?
@export var max_temperature : float = 1.1

@onready var color_rect: ColorRect = $Sprite2D/ColorRect
@onready var point_light: PointLight2D = $Sprite2D/PointLight2D
@onready var area_2d: Area2D = $Area2D
@onready var panel: Panel = $Panel

var rng = RandomNumberGenerator.new()
var tween : Tween

var current_scene: Node2D
var is_flickering : bool = false   # so we can check state

var is_chosen: bool

signal visible_machine(visible: bool)

func _ready() -> void:
	current_scene = get_parent().get_parent() # Not a good way but works
	connect("visible_machine", current_scene.chosen_machine_visible)
	area_2d.set_deferred("monitorable", false)
	area_2d.set_deferred("monitoring", false)
	rng.randomize()

func turn_on() -> void:
	color_rect.show()
	point_light.show()
	area_2d.set_deferred("monitorable", true)
	area_2d.set_deferred("monitoring", true)
	start_flicker()

func turn_off() -> void:
	color_rect.hide()
	point_light.hide()
	area_2d.set_deferred("monitorable", false)
	area_2d.set_deferred("monitoring", false)
	stop_flicker()

func start_flicker():
	if is_flickering:
		return
	is_flickering = true
	# Kill any leftover tween (just in case)
	_stop_tween()
	# Start the first segment
	_build_next_segment()

func stop_flicker():
	is_flickering = false
	_stop_tween()

func _stop_tween():
	if tween:
		tween.kill()
		tween = null

func restart_flicker():
	stop_flicker()
	start_flicker()

func _build_next_segment():
	if not is_flickering:
		return   # Do nothing if stopped

	# === Create a NEW tween for this segment ===
	tween = create_tween()   # fresh, not started yet

	# Random values
	var target_energy = rng.randf_range(min_energy, max_energy)
	var target_temp = rng.randf_range(min_temperature, max_temperature)
	
	var base_duration = 1.0 / flicker_speed
	var duration = rng.randf_range(base_duration * 0.5, base_duration * 2.0)
	
	# Occasional deep dip
	if rng.randf() < 0.2:
		duration *= 3.0
		target_energy = min_energy * 0.8
		target_temp = min_temperature * 0.9

	# Animate the light
	tween.tween_property(point_light, "energy", target_energy, duration)
	tween.parallel().tween_property(point_light, "color", _temperature_to_color(target_temp), duration)

	# Animate the ColorRect (alpha + tint)
	if color_rect:
		tween.parallel().tween_property(color_rect, "modulate:a", target_energy, duration)
		tween.parallel().tween_property(color_rect, "modulate", _temperature_to_color(target_temp), duration)

	# Chain the next segment – this callback runs when this tween finishes
	tween.tween_callback(_build_next_segment)

func _temperature_to_color(temp : float) -> Color:
	var r = clamp(temp, 0.8, 1.2)
	var g = clamp(temp, 0.8, 1.2)
	var b = clamp(temp * 0.9, 0.8, 1.2)
	return Color(r, g, b)

func _exit_tree():
	stop_flicker()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if is_chosen:
		visible_machine.emit(true)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if is_chosen:
		visible_machine.emit(false)

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if _body is Player:
		panel.show()
		current_scene.player_near_mach = true

func _on_area_2d_body_exited(_body: Node2D) -> void:
	if _body is Player:
		panel.hide()
		current_scene.player_near_mach = false




#EOF
