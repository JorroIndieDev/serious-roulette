extends BaseGun

func _shoot() -> void:
	super()
	if gun_sprite != null:
		gun_sprite.play("shoot")

func _on_sprite_2d_animation_finished() -> void:
	if gun_sprite.animation == "shoot":
		gun_sprite.play("normal")
