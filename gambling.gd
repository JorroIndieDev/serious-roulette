class_name GamblingNode extends Control

@onready var prize_wheel: Node2D = $Prize_Wheel
@onready var slot_machine: Node2D = $"Slot-Machine"
@onready var prize: Control = $Prize
@onready var buttons: HBoxContainer = $HBoxContainer


func _ready() -> void:
	prize.visible = false

func _on_button_pressed() -> void:
	prize_wheel.spin()
	buttons.visible = false

func _on_button_2_pressed() -> void:
	slot_machine.spin()
	buttons.visible = false

func show_prize(win_texture : Texture2D, win_title : String, win_desc : String):
	var texture:TextureRect = $Prize/Prize
	var shine:TextureRect =$Prize/Shine
	var title:Label = $Prize/text/Title
	var desc:Label = $Prize/text/Description
	#prize.scale = Vector2(0.1,0.1)
	shine.rotation = 0

	texture.texture = win_texture
	title.text = win_title
	desc.text = win_desc
	prize.visible = true
	var tween = create_tween()
	tween.tween_property(shine, "rotation", 3, 3)
	#tween.tween_property(prize, "scale", Vector2(1,1), 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	
	
	await get_tree().create_timer(3).timeout
	prize.visible = false
	buttons.visible = true
