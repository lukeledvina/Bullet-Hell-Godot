extends Node2D

var player_scene: PackedScene = preload("res://Scenes/player.tscn")
@onready var player: CharacterBody2D = $Player
var player_death_position: Vector2

var projectile_scene: PackedScene = preload("res://Scenes/player_projectile.tscn")
@onready var player_projectile_container: Node = $PlayerProjectiles
@onready var score_number_label: Label = $UserInterface/MarginContainer/VBoxContainer/ScoreNumber


func _ready():	
	for enemy in $Enemies.get_children():
		enemy.connect("enemy_killed", _on_enemy_killed)
		enemy.connect("enemy_projectile_created", _on_enemy_projectile_created)

		 
func _on_enemy_killed(score_value):
	Globals.score += score_value
	score_number_label.text = str(Globals.score)
	
func _on_enemy_projectile_created(projectile):
	projectile.connect("player_killed", _on_player_killed)
	
func _on_player_killed():
	player.death()

	
