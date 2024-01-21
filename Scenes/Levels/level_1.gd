extends Level

func _on_level_progress_area_entered(_area):
	spawn_enemies(floaty, 10, floaty_path_1, false, floaty_path_1_offset, floaty_time)
	spawn_enemies(floaty, 10, floaty_path_1, true, floaty_path_1_offset, floaty_time)


func _on_level_progress_2_area_entered(_area):
	spawn_enemies(eddy, 5, eddy_path_1, false, offset, eddy_time)


func _on_level_progress_3_area_entered(_area):
	offset = Vector2(0, 30)
	spawn_enemies(eddy, 5, eddy_path_1, true, offset, eddy_time)


func _on_level_progress_4_area_entered(_area):
	spawn_enemies(evil_floaty, 8, floaty_path_1, false, floaty_path_1_offset, floaty_time)
	spawn_enemies(evil_floaty, 8, floaty_path_1, false, floaty_path_1_offset + parallel_offset, floaty_time)


func _on_level_progress_5_area_entered(_area):
	spawn_enemies(floaty, 8, floaty_path_1, false, floaty_path_1_offset + Vector2(50, 0), 1)
	spawn_enemies(evil_floaty, 5, eddy_path_1, true, Vector2(0, -25), 3)


func _on_level_progress_6_area_entered(area):
	spawn_enemies(eddy, 8, floaty_path_1, false, floaty_path_1_offset + Vector2(100, -50), 2)
	spawn_enemies(eddy, 5, floaty_path_1, true, floaty_path_1_offset + Vector2(100, -50), 2)
	spawn_enemies(floaty, 15, eddy_path_1, false, Vector2(0, 100), 1.5)
