class_name BulletResource extends Resource


## Additive or multipliative damage the bullet adds to the gun
@export var bullet_damage: float
## Additive by default, enable for mutiplicative damage
@export var multiplicative: bool = false
## How many bodies it can pierce
@export var max_pierce: int = 0
## knockback of the bullet
@export var knock_back_force: int = 0

## Bullet base speed
@export var base_speed: float
## Speed to be used in calculations internally
var bullet_speed: float
## Scene of the bullet to spawn
@export var bullet_scene: PackedScene
