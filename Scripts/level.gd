extends Node2D

var projectile_scene: PackedScene = preload("res://Scenes/player_projectile.tscn")
var projectile_offset: Vector2 = Vector2(0, -8)
@onready var player_projectile_container: Node = $PlayerProjectiles
@onready var score_number_label: Label = $UserInterface/MarginContainer/VBoxContainer/ScoreNumber

func _ready():
	$Player.connect("shot", _on_player_shooting)
	
	for enemy in $Enemies.get_children():
		enemy.connect("enemy_killed", _on_enemy_killed)

		
func _on_player_shooting(player_pos):
		var projectile = projectile_scene.instantiate()
		player_projectile_container.add_child(projectile)
		projectile.global_position = player_pos + projectile_offset
		 
func _on_enemy_killed(score_value):
	Globals.score += score_value
	score_number_label.text = str(Globals.score)
