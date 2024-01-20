extends CharacterBody2D
class_name Boss

var can_attack: bool = true

@export var health: int = 5000
@export var speed: int = 100
@export var score_value: int = 100

var projectile_speed: int = 100

@export var damage_power_up_value: int = 1
@export var life_power_up_value: int = 1
@export var progress_speed: float = 100
@export var attack_point: float = 300
@export var projectile_scene: PackedScene = preload("res://Scenes/enemy_projectile.tscn")

#var spawn_point_count: int = 1
#var arc_degrees: int = 60
#var spacing: int = 15
#var rows: int = 5
#var radius: int = 20


@onready var rotater: Node2D = $Rotater
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var enemy_projectile_container: Node2D = $"../EnemyProjectiles"
@onready var player: CharacterBody2D = $"../Player"
@onready var boss_position_container: Node2D = $"../BossPositions"
var current_pos_index: int = 0
var position_amount: int = 3

var center_position: Vector2 = Vector2(640, 160)
# alternate position btwn points: 1,2,3 1,2,3, and then at phase change go back to center

# TODO: hook up projectile signal, get movement to work in a continuous loop

func _ready():
	global_position = center_position
	
	attack(3, 60, 2, 25, 15, 2, 2)


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
	
	#Tween.interpolate_value(global_position, new_position - global_position, 0,  movement_time, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)


func attack(spawn_point_count: int, arc_degrees: int, rows: int, radius: int, spacing: int, movement_time: float, post_attack_time: float):
	
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
	
	await get_tree().create_timer(post_attack_time).timeout


func _on_attack_cooldown_timer_timeout():
	can_attack = true
