extends Control

@onready var prize_wheel: Node2D = $Prize_Wheel



func _on_button_pressed() -> void:
	prize_wheel.spin()
