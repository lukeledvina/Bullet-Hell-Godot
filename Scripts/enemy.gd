extends CharacterBody2D
class_name Enemy

signal enemy_shooting(enemy_pos)
signal enemy_killed(score_value)
signal enemy_projectile_created(projectile)

var score_value: int = 100
var direction: Vector2

var can_attack: bool = true

var spawn_point_count: int = 3
var projectile_speed: int = 100
var arc_degrees: int = 60
var spacing: int = 15
var rows: int = 5
var radius: int = 20
var projectile_scene: PackedScene = preload("res://Scenes/enemy_projectile.tscn")
@onready var rotater: Node2D = $Rotater

@onready var player: CharacterBody2D = $"../../../../Player"

@onready var path_follow: PathFollow2D = $"../"
var progress_rate: float = 0.1
var attack_point: float = 0.3

var health: int = 1:
	set(value):
		if value <= 0:
			emit_signal("enemy_killed", score_value)
			queue_free()
		else:
			health = value
			

func _process(delta):
	path_follow.progress_ratio += progress_rate * delta
	
	if path_follow.progress_ratio >= attack_point:
		attack()
			
			
func _ready():
	#ignore this :))
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
	
	if can_attack:
		direction = (player.global_position - global_position).normalized()
		rotater.rotation_degrees = rad_to_deg(direction.angle())
		
		
		for point in rotater.get_children():
			var projectile = projectile_scene.instantiate()
			projectile.speed = projectile_speed
			var root = get_tree().get_root()
			var current_scene = root.get_child(root.get_child_count()-1)
			current_scene.add_child.call_deferred(projectile)
			projectile.global_position = point.global_position
			projectile.global_rotation = point.global_rotation
			call_deferred("emit_signal", "enemy_projectile_created", projectile)
		
	can_attack = false

