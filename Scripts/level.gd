extends Node2D

var bug: PackedScene = preload("res://Scenes/bug.tscn")

@onready var player: CharacterBody2D = $Game/Player
@onready var score_number_label: Label = $Game/UserInterface/MarginContainer/VBoxContainer/ScoreNumber
@onready var enemies: Node2D = $Game/Enemies/Path2D/PathFollow2D
@onready var game: Node2D = $Game
@onready var enemy_path: PathFollow2D = $Game/Enemies/Path2D/PathFollow2D

var game_scroll_speed: int = 5

func _process(delta):
	game.global_position.y -= game_scroll_speed * delta


func _on_enemy_killed(score_value):
	Globals.score += score_value
	score_number_label.text = str(Globals.score)


func _on_enemy_projectile_created(projectile):
	projectile.connect("player_killed", _on_player_killed)


func _on_player_killed():
	player.death()


func _on_level_progress_1_area_entered(_area):
	var new_bug = bug.instantiate()
	new_bug.connect("enemy_killed", _on_enemy_killed)
	new_bug.connect("enemy_projectile_created", _on_enemy_projectile_created)
	enemy_path.call_deferred("add_child", new_bug)
