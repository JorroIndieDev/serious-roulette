extends Node2D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		PlayerData._append_upgrade(UpgradeDB.available_upgrades[UpgradeDB.UPGRADES.MOVESPEED])
		print(PlayerData.upgrades_list)
