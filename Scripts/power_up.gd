extends Area2D

signal collected()

var speed: int = 100
# on spawn, go up, and then start falling, once you reach a max speed, keep it constant

func _physics_process(delta):
	global_position.y += speed * delta


func _on_body_entered(_body):
	emit_signal("collected")
	queue_free()


func _on_despawn_timer_timeout():
	queue_free()
