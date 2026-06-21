extends Node2D

signal prize_won(reward: String)

@export var num_prizes: int = 8
@export var spins: int = 5
@export var spin_duration: int = 4
@onready var background: Sprite2D = $Background

@export var height_to_slide: float = 400
@export var time_to_slide: float = 0.5
@export var display_duration: float = 1.5

@export var prize_pool: Array[Texture2D]
@onready var prize: Control = $"../Prize"

var offscreen_y: float
var onscreen_y: float
var winning_texture: Texture2D
var is_spinnin: bool = false

func _ready() -> void:
	offscreen_y = position.y
	onscreen_y = offscreen_y - height_to_slide
	position.x = get_viewport_rect().size.x/2

func spin():
	var icons_container = $Background/PrizeContainer
	
	for i in range(num_prizes):
		var prize_sprite = icons_container.get_child(i) as Sprite2D
		prize_sprite.texture = prize_pool.pick_random()
		
	var winning_index = randi() % num_prizes
	
	var winning_sprite = icons_container.get_child(winning_index) as Sprite2D
	var won_texture = winning_sprite.texture.resource_name.remove_chars(".png")
	winning_texture = winning_sprite.texture
	
	background.rotation = 0.0
	
	var slice_angle = TAU / num_prizes 
	
	var target_offset = TAU - (winning_index * slice_angle)
	if winning_index == 0:
		target_offset = 0.0
		
	var distance_to_target = target_offset - rotation
	if distance_to_target < 0:
		distance_to_target = 0.0
	
	var target_angle = rotation + (spins * TAU) + distance_to_target - slice_angle/2
	
	var tween = create_tween()
	tween.tween_property(self, "position:y", onscreen_y, time_to_slide).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(background, "rotation", target_angle, spin_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	prize_won.emit(won_texture)
	$"..".show_prize(winning_texture, winning_texture.resource_name, "text")
	await get_tree().create_timer(display_duration).timeout
	
	
	var tween_out = create_tween()
	tween_out.tween_property(self, "position:y", offscreen_y, time_to_slide).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	background.rotation == 0


	
	
