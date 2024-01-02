extends Area2D

var speed: int = 600
var enemy_layer: int = 2
var boundary_layer: int = 16

func _physics_process(delta):
	global_position.y -= speed * delta


func _on_body_entered(body):
	if body.collision_layer == enemy_layer:
		body.health -= Globals.player_damage

	queue_free()
