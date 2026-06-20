extends Node


func _spawn_bullet(bullet: BasicBullet) -> void:
	%Bulletcontainer.add_child(bullet)
