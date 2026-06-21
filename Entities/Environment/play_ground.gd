extends Node2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		PlayerData._append_upgrade(
			UpgradeDB.available_upgrades[Upgrade.ID.GUNDMGUP]
			)
		print_debug(PlayerData.upgrades_list)
