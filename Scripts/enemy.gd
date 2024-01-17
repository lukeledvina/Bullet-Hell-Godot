extends CharacterBody2D
class_name Enemy

signal enemy_shooting(enemy_pos)
signal enemy_killed(score_value)
signal enemy_projectile_created(projectile)


var can_attack: bool = true

@onready var damage_power_up_progress: int = 1
@onready var life_power_up_progress: int = 1
@export var score_value: int = 100
@export var progress_speed: float = 100
@export var attack_point: float = 300
@export var spawn_point_count: int = 1
@export var projectile_speed: int = 100
@export var arc_degrees: int = 60
@export var spacing: int = 15
@export var rows: int = 5
@export var radius: int = 20
@export var projectile_scene: PackedScene = preload("res://Scenes/enemy_projectile.tscn")


@onready var rotater: Node2D = $Rotater
@onready var animation_player = $AnimationPlayer

@onready var player: CharacterBody2D = $"../../../../Player"
@onready var enemy_projectile_container: Node2D = $"../../../../EnemyProjectiles"

@onready var path_follow: PathFollow2D = $"../"

var health: int = 1:
	set(value):
		if value <= 0:
			emit_signal("enemy_killed", score_value, damage_power_up_progress, life_power_up_progress)
			queue_free()
		else:
			health = value
			

func _process(delta):
	path_follow.progress += progress_speed * delta
	
	if path_follow.progress >= attack_point:
		attack()
			
	if path_follow.progress_ratio >= 1:
		queue_free()
		

func _ready():
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
		

func attack():
	
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
		
	can_attack = false

