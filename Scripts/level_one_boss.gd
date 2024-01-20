extends Boss

func pattern():
	await get_tree().create_timer(2).timeout
	while true:
		attack(3, 60, 2, 25, 15, 2)
		await get_tree().create_timer(5).timeout
		attack(5, 90, 6, 25, 15, 2)
		await get_tree().create_timer(5).timeout
		attack(10, 60, 3, 25, 15, 2)
		await get_tree().create_timer(5).timeout
