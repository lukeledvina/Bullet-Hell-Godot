extends CharacterBody2D
class_name Enemy

signal enemy_shooting(enemy_pos)
signal enemy_killed(score_value)
var score_value: int = 100

var health: int = 1:
	set(value):
		if value <= 0:
			emit_signal("enemy_killed", score_value)
			queue_free()
		else:
			health = value


func _on_projectile_cooldown_timeout():
	emit_signal("enemy_shooting", global_position)
	
