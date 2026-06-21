extends Node2D

signal prize_won(reward: String)

@onready var background: AnimatedSprite2D = $Background
@onready var numbers: AnimatedSprite2D = $Numbers
@onready var prize: Control = $"../Prize"

@export var spin_duration: float = 2.0
@export var height_to_slide: float = 170
@export var time_to_slide: float = 0.5
@export var display_duration: float = 2.5

@export var prize_pool: Array[Texture2D]

var offscreen_y: float
var onscreen_y: float
var winning_texture: Texture2D
var num_prizes: int = 3
@onready var icons_container: Node2D = $PrizeContainer

func _ready() -> void:
	offscreen_y = position.y
	onscreen_y = offscreen_y - height_to_slide
	position.x = get_viewport_rect().size.x/2
	icons_container.visible = false
	numbers.visible = true
	icons_container.visible = false
	for i in range(3):
		var prize_sprite = icons_container.get_child(i) as Sprite2D
		prize_sprite.texture = null
	

func spin():
	numbers.visible = true
	icons_container.visible = false
	for i in range(3):
		var prize_sprite = icons_container.get_child(i) as Sprite2D
		prize_sprite.texture = null
	var winning_texture = prize_pool.pick_random()
	
	background.play("Spinning")
	numbers.play("Spin")
	var tween = create_tween()
	tween.tween_property(self, "position:y", onscreen_y, time_to_slide).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await tween.finished
	
	await get_tree().create_timer(spin_duration).timeout
	
	background.play("stop")
	numbers.visible = false
	
	icons_container.visible = true
	for i in range(3):
		var prize_sprite = icons_container.get_child(i) as Sprite2D
		prize_sprite.texture = winning_texture
		await get_tree().create_timer(0.2).timeout
		
	$"..".show_prize(winning_texture, winning_texture.resource_name, "text")
	await get_tree().create_timer(display_duration).timeout
	
	prize_won.emit(winning_texture.resource_name)
	var tween_out = create_tween()
	tween_out.tween_property(self, "position:y", offscreen_y, time_to_slide).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
