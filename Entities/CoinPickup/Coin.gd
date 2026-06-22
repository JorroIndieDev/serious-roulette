class_name Coin extends Node2D

@export var coin_data: CoinData

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
# Bobbing parameters (you can export them to tweak in the inspector)
@export var bob_height: float = 3.5      # how far it moves up/down (in pixels)
@export var bob_duration: float = 1.4     # time for one full up‑and‑down cycle

var _bob_tween: Tween = null

func _ready() -> void:
	if !coin_data:
		printerr("NO COIN DATA")
		return
	animate_bobbing()


func animate_bobbing() -> void:
	# Stop any existing bob tween
	if _bob_tween and _bob_tween.is_valid():
		_bob_tween.kill()

	# Get the starting Y position of the sprite
	var start_y := animated_sprite.position.y

	# Create a new tween
	_bob_tween = create_tween()
	_bob_tween.set_loops()   # loop forever

	# Move up (decrease Y) and down (increase Y) in a smooth sine‑like motion
	_bob_tween.tween_property(animated_sprite, "position:y", start_y - bob_height, bob_duration * 0.5)
	_bob_tween.tween_property(animated_sprite, "position:y", start_y, bob_duration * 0.5)


func _on_pick_up_body_entered(body: Node2D) -> void:
	if body is Player and coin_data:
		PlayerData.player_coins = coin_data.coin_value


func _on_pick_up_area_body_entered(body: Node2D) -> void:
	if body is Player:
		magnet_to_target(body)



func magnet_to_target(target: Node2D, duration: float = 2.5) -> void:
	var tween = create_tween()
	# Use EASE_OUT_QUINT for a quick start and smooth stop (like a magnet snap)
	tween.tween_property(self, "global_position", target.global_position, duration)\
		 .set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
