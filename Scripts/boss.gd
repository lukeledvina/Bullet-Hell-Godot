extends CharacterBody2D
class_name Boss

signal enemy_projectile_created(projectile)
signal boss_killed(boss_position, damage_power_up_amount, life_power_up_amount)

var can_attack: bool = true

@export var health: int = 5000:
	set(value):
		health = value
		if health <= 0:
			emit_signal("boss_killed", global_position, 5, 5)
			queue_free()
@export var score_value: int = 100

var position_amount: int

var projectile_speed: int = 100

@export var projectile_scene: PackedScene = preload("res://Scenes/enemy_projectile.tscn")

@onready var rotater: Node2D = $Rotater
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var enemy_projectile_container: Node2D = $"../EnemyProjectiles"
@onready var player: CharacterBody2D = $"../Player"
@onready var boss_position_container: Node2D = $"../BossPositions"
var current_pos_index: int = 0




# alternate position btwn points: 1,2,3 1,2,3, and then at phase change go back to center

func _ready():
	for i in boss_position_container.get_children():
		position_amount += 1
	pattern()

func pattern():
	pass

func attack(spawn_point_count: int, arc_degrees: int, rows: int, radius: int, spacing: int, movement_time: float):
	
	attack_setup(spawn_point_count, arc_degrees, rows, radius, spacing)
	
	move(boss_position_container.get_child(current_pos_index).global_position, movement_time)
	
	await get_tree().create_timer(movement_time + 0.1).timeout
	
	if can_attack and Globals.player_alive:
		var direction: Vector2 = (player.global_position - global_position).normalized()
		rotater.rotation_degrees = rad_to_deg(direction.angle())
		
		
		for point in rotater.get_children():
			var projectile = projectile_scene.instantiate()
			projectile.speed = projectile_speed
			enemy_projectile_container.add_child.call_deferred(projectile)
			projectile.global_position = point.global_position
			projectile.global_rotation = point.global_rotation
			call_deferred("emit_signal", "enemy_projectile_created", projectile)
			
			point.queue_free()
		
	current_pos_index += 1
	if current_pos_index >= position_amount:
		current_pos_index = 0
		
	can_attack = false
	attack_cooldown_timer.start()


func attack_setup(spawn_point_count, arc_degrees, rows, radius, spacing):
	#ignore this :))
	if spawn_point_count != 0:
		spawn_point_count += 1
	
	var step = (arc_degrees * PI/180) / spawn_point_count
	var current_spacing = 0
	for i in rows:
		var alternator: int = 1
		for k in range(spawn_point_count):		
			var spawn_point = Node2D.new()
			var pos = Vector2(radius + current_spacing, 0).rotated(step * k * alternator)
			if alternator == -1:
				pos = Vector2(radius + current_spacing, 0).rotated(step * (k - 1) * alternator)
			spawn_point.position = pos
			spawn_point.rotation = pos.angle()
			rotater.add_child(spawn_point)
			alternator = -alternator
			
		current_spacing += spacing

func move(new_position: Vector2, movement_time: float):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", new_position, movement_time)


func _on_attack_cooldown_timer_timeout():
	can_attack = true
