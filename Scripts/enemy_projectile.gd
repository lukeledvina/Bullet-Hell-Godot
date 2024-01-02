extends Area2D

signal player_killed()

var speed: int = 100
var player_layer: int = 1
var boundary_layer: int = 16

func _physics_process(delta):
	global_position.y += speed * delta

func _on_body_entered(body):
	if body.collision_layer == player_layer:
		Globals.player_health -= 1
		if Globals.player_health <= 0:
			emit_signal("player_killed")

	queue_free()
