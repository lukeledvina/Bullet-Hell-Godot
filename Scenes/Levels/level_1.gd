extends Level

var floaty: PackedScene = preload("res://Scenes/Enemies/floaty.tscn")
var floaty_path_1_scene: PackedScene = preload("res://Scenes/EnemyPaths/floaty_path_1.tscn")

func _on_level_progress_area_entered(_area):
	var offset = Vector2(300, 0)
	spawn_enemies(10, create_path(floaty_path_1_scene, false, offset), floaty, 0.2)
	
	spawn_enemies(10, create_path(floaty_path_1_scene, true, offset), floaty, 0.2)


func create_path(path_scene: PackedScene, reverse: bool, offset: Vector2) -> Path2D:
	var path = path_scene.instantiate()
	enemy_paths.add_child(path)
	if reverse:
		path_reverse(path)
		path.position -= offset
	else:
		path.position += offset
	path.position.x += 640
	return path
