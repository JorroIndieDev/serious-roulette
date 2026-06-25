class_name ArrowPointer 
extends CanvasLayer

@export var edge_offset: float = 30.0
@export var rotation_offset: float = 0.0   
@export var sprite: Sprite2D

var _target: Node2D = null
#var _debug_counter: int = 0

func _ready():
	if not sprite:
		sprite = find_child("Sprite2D", true, false)
	if not sprite:
		push_warning("Arrow: No Sprite2D found.")
	hide()

func set_target(target: Node2D) -> void:
	_target = target
	if target:
		show()
		print("Arrow: Target set to ", target.name)
	else:
		hide()

func clear_target() -> void:
	_target = null
	hide()

func _process(_delta: float) -> void:
	
	var player = PlayerData.player_ref
	
	if not _target or not sprite:
		return

	if not player:
		print("Arrow: PlayerData.player_ref is null!")
		return

	# Optional: verify player is not the camera (if your camera is named "Camera2D")
	if player.name == "Camera2D" or player is Camera2D:
		print("Arrow: PlayerData.player_ref is a camera! Please set it to the actual player node.")
		# Fallback: try to find a player by group
		var nodes = get_tree().get_nodes_in_group("player")
		if nodes.size() > 0:
			player = nodes[0]
			print("Arrow: Using player from group: ", player.name)

	var cam = get_viewport().get_camera_2d()
	if not cam:
		return

	var viewport_size = get_viewport().get_visible_rect().size
	var screen_center = viewport_size / 2.0

	# Convert player and target to screen pixels
	var player_screen = (player.global_position - cam.global_position) * cam.zoom + screen_center
	var target_screen = (_target.global_position - cam.global_position) * cam.zoom + screen_center

	var dir_vec = target_screen - player_screen
	if dir_vec.length() < 0.001:
		dir_vec = Vector2(1, 0)

	var dir_norm = dir_vec.normalized()
	var half_w = viewport_size.x / 2.0 - edge_offset
	var half_h = viewport_size.y / 2.0 - edge_offset

	# Place arrow on the edge along the direction from player to target
	var edge_pos = player_screen
	if abs(dir_norm.x) > abs(dir_norm.y):
		var t = half_w / abs(dir_norm.x)
		var y = player_screen.y + dir_norm.y * t
		y = clamp(y, screen_center.y - half_h, screen_center.y + half_h)
		edge_pos = Vector2(screen_center.x + dir_norm.x * half_w, y)
	else:
		var t = half_h / abs(dir_norm.y)
		var x = player_screen.x + dir_norm.x * t
		x = clamp(x, screen_center.x - half_w, screen_center.x + half_w)
		edge_pos = Vector2(x, screen_center.y + dir_norm.y * half_h)

	sprite.position = edge_pos
	# Calculate angle from arrow position to target, then add offset
	var angle = edge_pos.angle_to_point(target_screen)
	sprite.rotation = angle + rotation_offset

	## Debug every 60 frames
	#_debug_counter += 1
	#if _debug_counter % 60 == 0:
		#print("Player world: ", player.global_position)
		#print("Target world: ", _target.global_position)
		#print("Edge pos: ", edge_pos)
		#print("Sprite pos: ", sprite.position)
