extends Node2D
class_name Level

@onready var player: CharacterBody2D = $Game/Player
@onready var score_number_label: Label = $UserInterface/MarginContainer/MainContainer/ScoreContainer/ScoreNumber
@onready var lives_number_label: Label = $UserInterface/MarginContainer/MainContainer/LivesContainer/LivesNumber
@onready var game: Node2D = $Game
@onready var enemy_projectile_container: Node2D = $Game/EnemyProjectiles
@onready var borders: Node2D = $Game/Borders
@onready var enemy_paths: Node2D = $Game/EnemyPaths

var game_scroll_speed: int = 1

func _ready():
	borders.visible = true

func _process(delta):
	game.global_position.y -= game_scroll_speed * delta


func _on_enemy_killed(score_value):
	Globals.score += score_value
	score_number_label.text = str(Globals.score)


func _on_enemy_projectile_created(projectile):
	projectile.connect("player_killed", _on_player_killed)


func _on_player_killed():
	for projectile in enemy_projectile_container.get_children():
		projectile.queue_free()
	
	player.death()
	lives_number_label.text = str(Globals.player_lives)

func spawn_enemies(amount: int, path: Path2D, enemy_type: PackedScene, time_between: float):
	for i in range(amount):
		var path_follow: PathFollow2D = PathFollow2D.new()
		path_follow.rotates = false
		path_follow.loop = false
		var new_enemy: CharacterBody2D = enemy_type.instantiate()
		path_follow.add_child(new_enemy)
		new_enemy.connect("enemy_killed", _on_enemy_killed)
		new_enemy.connect("enemy_projectile_created", _on_enemy_projectile_created)
		path.call_deferred("add_child", path_follow)
		await get_tree().create_timer(time_between).timeout

func path_reverse(path: Path2D):
	var new_curve: Curve2D = Curve2D.new()
	var points = path.curve.get_baked_points()
	#path.curve.clear_points()
	for point in points:
		var new_point = point.reflect(Vector2.UP)
		new_curve.add_point(new_point)
	path.curve = new_curve
	return path
	
