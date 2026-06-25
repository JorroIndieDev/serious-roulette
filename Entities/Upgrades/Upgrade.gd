class_name Upgrade extends Resource


enum ID {
	MOVESPEED,
	GUNDMGUP,
	BULLETDMGUP,
	# Add more here as you create them
}

@export var id: ID           # The unique identifier
@export var name: String
@export var description: String
@export var texture: Texture2D

@export var max_stacks: int 
var upgrade_stack: int = 0

func _stack_upgrade(_u: Upgrade) -> Upgrade:
	assert(false, "Abstract function")
	return null

func _apply_upgrade(_object: Variant) -> void:
	assert(false, "Abstract function")
