extends CharacterBody2D

signal shot(player_pos)

var direction: Vector2
var speed: int = 300

var can_shoot: bool = true
var player_death_position: Vector2
var can_be_damaged: bool = true

@onready var spawn_pos: Vector2 = global_position


@onready var player_death_timer: Timer = $PlayerDeathTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _process(_delta):
	if Input.is_action_pressed("shoot") and can_shoot:
		emit_signal("shot", global_position)
		can_shoot = false
		$ProjectileCooldown.start()
		
	
func _physics_process(_delta):
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = speed * direction
	move_and_slide()
	

func death():
	if can_be_damaged:
		Globals.player_lives -= 1
		print(Globals.player_lives)
		# an animation where the player becomes invincible and flashes / goes invisible for 1 sec
		animation_player.play("death")
		collision_shape.call_deferred("set_disabled", true)
		
		player_death_timer.start()
		can_be_damaged = false



func _on_projectile_cooldown_timeout():
	can_shoot = true


func _on_player_death_timer_timeout():
	collision_shape.call_deferred("set_disabled", false)
	global_position = spawn_pos
	can_be_damaged = true
