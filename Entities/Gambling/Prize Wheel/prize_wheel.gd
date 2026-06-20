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
	
	var slice_angle = TAU / num_prizes 
	var base_spins = spins * TAU + slice_angle/2
	
	var current_spins = snapped(rotation, TAU)
	var target_angle = current_spins + base_spins + (winning_index + slice_angle)
	
	var tween = create_tween()
	tween.tween_property(self, "position:y", onscreen_y, time_to_slide).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(background, "rotation", target_angle, spin_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	prize_won.emit(won_texture)
	await get_tree().create_timer(display_duration).timeout
	
	var tween_out = create_tween()
	tween_out.tween_property(self, "position:y", offscreen_y, time_to_slide).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)

func show_prize():
	var texture:TextureRect = $"prize.Prize"
	var shine:TextureRect = $"prize.Shine"
	var title:Label = $"prize.text.Title"
	var desc:Label = $"prize.text.Description"

	texture.texture = winning_texture
	var tween = create_tween()
	tween.tween_property(shine, "rotation", 720, 1.5).set_trans(Tween.TRANS_QUAD)
	title.text = winning_texture.resource_name.remove_chars(".png")
	desc.text = "Insert description here"
	
	
