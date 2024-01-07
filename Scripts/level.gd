extends Node2D

var bug: PackedScene = preload("res://Scenes/bug.tscn")

@onready var player: CharacterBody2D = $Game/Player
@onready var score_number_label: Label = $UserInterface/MarginContainer/MainContainer/ScoreContainer/ScoreNumber
@onready var lives_number_label: Label = $UserInterface/MarginContainer/MainContainer/LivesContainer/LivesNumber
@onready var game: Node2D = $Game
@onready var enemy_path_1: Path2D = $Game/Enemies/Path2D
@onready var enemy_path_2: Path2D = $Game/Enemies/Path2D2
@onready var enemy_projectile_container: Node = $EnemyProjectiles

var game_scroll_speed: int = 1

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

func spawn_enemies(amount: int, path: Path2D, enemy_type: PackedScene, time: float):
	for i in range(amount):	
		var path_follow: PathFollow2D = PathFollow2D.new()
		path_follow.rotates = false
		path_follow.loop = false
		var new_enemy: CharacterBody2D = enemy_type.instantiate()
		path_follow.add_child(new_enemy)
		new_enemy.connect("enemy_killed", _on_enemy_killed)
		new_enemy.connect("enemy_projectile_created", _on_enemy_projectile_created)
		path.call_deferred("add_child", path_follow)
		await get_tree().create_timer(time).timeout

func _on_level_progress_1_area_entered(_area):
	spawn_enemies(10, enemy_path_1, bug, 0.3)

func _on_level_progress_2_area_entered(_area):
	spawn_enemies(15, enemy_path_2, bug, 0.3)
