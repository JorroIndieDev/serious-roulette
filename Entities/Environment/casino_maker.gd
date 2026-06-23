extends Node2D

@export var slot_machine_scene: PackedScene

@export var rows: int = 12
@export var machines_per_row: int = 60

@export var spacing: Vector2 = Vector2(15, 50)

@export_range(0.0, 1.0) var chance_to_skip: float = 0.5

func _ready() -> void:
	generate_aisles()
	
func generate_aisles() -> void:
	for row_index in rows:
		for col_index in machines_per_row:
			if randf() < chance_to_skip:
				continue
			var machine = slot_machine_scene.instantiate()
			var offset_x = col_index * spacing.x
			var offset_y = row_index * spacing.y
			
			machine.position = Vector2(offset_x, offset_y)
			
			machine.position.x += randf_range(-1.0, 1.0)
			machine.position.y += randf_range(-1.0, 1.0)
			
			add_child(machine)
