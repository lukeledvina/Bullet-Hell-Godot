extends Area2D

var speed: int = 600

func _physics_process(delta):
	global_position.y += -1 * speed * delta
