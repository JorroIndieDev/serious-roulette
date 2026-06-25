extends BaseBullet

@export var explosion: PackedScene
@export var isRocket: bool
@export var rocketBoom: AudioStream
@export var fireballBoom: AudioStream
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _ready() -> void:
	super()
	if direction.x < 0:
		sprite_2d.flip_h = true
	if isRocket:
		sprite_2d.play("rocket")
	else:
		sprite_2d.play("fireball")

func _on_hit(area: Area2D) -> void:
	if area.owner is BaseBullet:
		return # The fix... 
	if area is HitBoxComponent:
		var boom = explosion.instantiate()
		if isRocket:
			boom.explode_sound = rocketBoom
		else:
			boom.explode_sound = fireballBoom
		boom.position = self.global_position
		GameManager.ProjectileContainer.add_child(boom)
		area.damage(attack)
	self.queue_free()
