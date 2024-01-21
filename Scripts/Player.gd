extends CharacterBody2D

var projectile_scene: PackedScene = preload("res://Scenes/player_projectile.tscn")

var direction: Vector2
var speed: float = 300
var max_speed: float = 300
var slow_modifier: float = 0.5

var can_shoot: bool = true
var can_be_damaged: bool = true


@onready var spawn_pos: Vector2 = global_position
@onready var player_death_timer: Timer = $PlayerDeathTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var projectile_cooldown: Timer = $ProjectileCooldown
@onready var player_projectile_container: Node2D = $"../PlayerProjectiles"
@onready var level: Node2D = $"../../"
@onready var shoot_sound_player: AudioStreamPlayer = $ShootSoundPlayer
@onready var invincibilty_timer: Timer = $InvincibilityTimer


func _process(delta):
	if Input.is_action_pressed("shoot") and can_shoot:
		var projectile = projectile_scene.instantiate()
		projectile.global_position = global_position
		player_projectile_container.add_child.call_deferred(projectile)
		can_shoot = false
		projectile_cooldown.start()
		shoot_sound_player.play()
		
	if Input.is_action_pressed("slow"):
		speed = max_speed * slow_modifier
	elif not Globals.player_alive:
		global_position.y -= level.game_scroll_speed * delta
		speed = 0
	else:
		speed = max_speed

	
func _physics_process(_delta):
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = speed * direction
	
	
	move_and_slide()
	

func death():
	if can_be_damaged:
		Globals.player_lives -= 1
		# an animation where the player becomes invincible and flashes / goes invisible for 1 sec
		animation_player.play("death")
		collision_shape.call_deferred("set_disabled", true)
		
		player_death_timer.start()
		Globals.player_alive = false
		can_be_damaged = false



func _on_projectile_cooldown_timeout():
	can_shoot = true


func _on_player_death_timer_timeout():
	position = spawn_pos
	Globals.player_alive = true
	invincibilty_timer.start()
	
func _on_invincibility_timer_timeout():
	collision_shape.call_deferred("set_disabled", false)
	can_be_damaged = true
