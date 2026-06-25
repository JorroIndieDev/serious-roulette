extends BaseGun

func _shoot() -> void:
	super()
	if gun_sprite_animated != null:
		gun_sprite_animated.play("shoot")

func _on_sprite_2d_animation_finished() -> void:
	if gun_sprite_animated.animation == "shoot":
		gun_sprite_animated.play("normal")
