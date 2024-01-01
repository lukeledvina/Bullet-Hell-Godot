extends CharacterBody2D

var direction: Vector2
var speed: int = 300

var can_shoot: bool = true

signal shot(player_pos)

func _process(_delta):
	if Input.is_action_pressed("shoot") and can_shoot:
		emit_signal("shot", global_position)
		can_shoot = false
		$ProjectileCooldown.start()
		
	
func _physics_process(_delta):
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = speed * direction
	move_and_slide()


func _on_projectile_cooldown_timeout():
	can_shoot = true
