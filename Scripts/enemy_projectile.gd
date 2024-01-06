extends Area2D

signal player_killed()

var speed: int = 100
var player_layer: int = 1



func _physics_process(delta):
	global_position += speed * delta * transform.x

func _on_body_entered(body):
	if body.collision_layer == player_layer:
		emit_signal("player_killed")

	queue_free()
