class_name BulletResource extends Resource


## Additive or multipliative damage the bullet adds to the gun
@export var bullet_damage: float
## Additive by default, enable for mutiplicative damage
@export var multiplicative: bool = false

## Bullet base speed
@export var base_speed: float
## Speed to be used in calculations internally
var bullet_speed: float
## Scene of the bullet to spawn
@export var bullet_scene: PackedScene
