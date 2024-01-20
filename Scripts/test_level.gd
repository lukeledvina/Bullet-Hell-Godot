extends Level

var level_one_boss_scene: PackedScene = preload("res://Scenes/Bosses/level_one_boss.tscn")

func _on_level_progress_area_entered(_area):
	var boss = level_one_boss_scene.instantiate()
	$Game.call_deferred("add_child", boss)
	boss.global_position = boss_center_position
	boss.connect("enemy_projectile_created", _on_enemy_projectile_created)
	boss.connect("boss_killed", _on_boss_killed)
