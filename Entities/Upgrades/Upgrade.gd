class_name Upgrade extends Resource

@export var name: String
@export var description: String
@export var texture: Texture2D

@export var max_stacks: int 
var upgrade_stack: int = 0

func _stack_upgrade(_u: Upgrade) -> void:
	assert(false, "Abstract function")
