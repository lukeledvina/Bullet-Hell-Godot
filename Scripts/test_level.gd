extends Level

var level_one_boss_scene: PackedScene = preload("res://Scenes/Bosses/level_one_boss.tscn")

func _on_level_progress_area_entered(_area):
	spawn_enemies(floaty, 30, eddy_path_1, false, Vector2(0, 300), 0.5)


func _on_level_progress_2_area_entered(_area):
	spawn_enemies(evil_floaty, 10, floaty_path_1, false, floaty_path_1_offset + Vector2(100, -50), 1)
	spawn_enemies(evil_floaty, 10, floaty_path_1, true, floaty_path_1_offset + Vector2(100, -50), 1)
