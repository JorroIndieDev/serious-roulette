class_name PlayerCamera extends Camera2D

const MAX_DISTANCE: int = 15

var target_distance: int = 0
var center_pos: Vector2 = self.position
## Screen shake
@export var default_duration: float = .5
## Screen shake
@export var default_strength: float = 0.5

var _shake_tween: Tween = null

func _process(_delta: float) -> void:
	var direction = center_pos.direction_to(get_local_mouse_position())
	var target_pos = center_pos + direction * target_distance
	
	target_pos = target_pos.clamp(
		center_pos - Vector2(MAX_DISTANCE, MAX_DISTANCE),
		center_pos + Vector2(MAX_DISTANCE, MAX_DISTANCE)
	)
	self.position = target_pos

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		target_distance = center_pos.distance_to(get_local_mouse_position()) / 2


func shake(duration: float = default_duration, strength: float = default_strength) -> void:
	if _shake_tween and _shake_tween.is_valid():
		_shake_tween.kill()
	
	var base_offset = offset
	_shake_tween = create_tween()
	_shake_tween.tween_method(
		func(progress: float):
			var random_vec = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
			offset = base_offset + random_vec * strength * progress
			,
		1.0, 0.0, duration
	)
	_shake_tween.finished.connect(func(): offset = base_offset; _shake_tween = null, CONNECT_ONE_SHOT)
