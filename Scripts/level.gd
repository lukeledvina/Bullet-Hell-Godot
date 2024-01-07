extends Node2D

var bug: PackedScene = preload("res://Scenes/bug.tscn")

@onready var player: CharacterBody2D = $Game/Player
@onready var score_number_label: Label = $Game/UserInterface/MarginContainer/VBoxContainer/ScoreNumber
@onready var enemies: Node2D = $Game/Enemies/Path2D/PathFollow2D
@onready var game: Node2D = $Game
@onready var enemy_path: Path2D = $Game/Enemies/Path2D
@onready var enemy_projectile_container: Node = $EnemyProjectiles

var game_scroll_speed: int = 5

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


func _on_level_progress_1_area_entered(_area):
	for i in range(10):	
		var path_follow: PathFollow2D = PathFollow2D.new()
		path_follow.rotates = false
		path_follow.loop = false
		var new_bug: CharacterBody2D = bug.instantiate()
		path_follow.add_child(new_bug)
		new_bug.connect("enemy_killed", _on_enemy_killed)
		new_bug.connect("enemy_projectile_created", _on_enemy_projectile_created)
		enemy_path.call_deferred("add_child", path_follow)
		await get_tree().create_timer(0.3).timeout
		
