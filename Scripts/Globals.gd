extends Node

var player_lives: int = 3:
	set(value):
		player_lives = value
		if player_lives <= 0:
			game_over()
var player_damage: int = 100
var player_projectile_scale: float = 1.0
var player_projectile_speed: float = 600
var score: int = 0

var player_alive: bool = true

func game_over():
	player_lives = 3
	score = 0
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/main_menu.tscn")
