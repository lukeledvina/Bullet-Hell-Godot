extends Node2D

var projectile_scene: PackedScene = preload("res://Scenes/player_projectile.tscn")
var projectile_offset: Vector2 = Vector2(0, -8)
@onready var player_projectile_container: Node = $PlayerProjectiles
@onready var score_number_label: Label = $UserInterface/MarginContainer/VBoxContainer/ScoreNumber

var enemy_projectile_scene: PackedScene = preload("res://Scenes/enemy_projectile.tscn")
@onready var enemy_projectile_container: Node = $EnemyProjectiles

func _ready():
	$Player.connect("shot", _on_player_shooting)
	
	for enemy in $Enemies.get_children():
		enemy.connect("enemy_killed", _on_enemy_killed)
		enemy.connect("enemy_shooting", _on_enemy_shooting)

		
func _on_player_shooting(player_pos):
	var projectile = projectile_scene.instantiate()
	player_projectile_container.add_child(projectile)
	projectile.global_position = player_pos + projectile_offset
		 
func _on_enemy_killed(score_value):
	Globals.score += score_value
	score_number_label.text = str(Globals.score)
	
func _on_enemy_shooting(enemy_pos):
	var enemy_projectile = enemy_projectile_scene.instantiate()
	enemy_projectile.connect("player_killed", _on_player_killed)
	enemy_projectile_container.add_child(enemy_projectile)
	enemy_projectile.global_position = enemy_pos - projectile_offset
	
	
func _on_player_killed():
	$Player.queue_free()
