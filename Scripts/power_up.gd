extends Area2D

signal collected()

var speed: int = 50
# on spawn, go up, and then start falling, once you reach a max speed, keep it constant

func ready():
	#var movement_tween = get_tree().create_tween()
	#
	#movement_tween.tween_property(self, "position", Vector2(0, -100), 1)
	#movement_tween.tween_property(self, "position", Vector2(0, 300), 3)
	pass

func _physics_process(delta):
	global_position.y += speed * delta


func _on_body_entered(_body):
	emit_signal("collected")
	queue_free()


func _on_despawn_timer_timeout():
	queue_free()
