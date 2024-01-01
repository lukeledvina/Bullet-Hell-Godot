extends Node2D

var projectile_scene: PackedScene = preload("res://Scenes/projectile.tscn")
var projectile_offset: Vector2 = Vector2(0, -16)
@onready var player_projectile_container: Node = $PlayerProjectiles

func _ready():
	$Player.connect("shot", _on_player_shooting)

		
func _on_player_shooting(player_pos):
		var projectile = projectile_scene.instantiate()
		player_projectile_container.add_child(projectile)
		projectile.global_position = player_pos + projectile_offset
		 
