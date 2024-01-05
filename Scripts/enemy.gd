extends CharacterBody2D
class_name Enemy

signal enemy_shooting(enemy_pos)
signal enemy_killed(score_value)
var score_value: int = 100
var direction: Vector2


var spawn_point_count: int = 3
var projectile_speed: int = 100
var arc_degrees: int = 30
var spacing: int = 15
var rows: int = 5
var radius: int = 20
var projectile_scene = preload("res://Scenes/enemy_projectile.tscn")
@onready var rotater = $Rotater

var health: int = 1:
	set(value):
		if value <= 0:
			emit_signal("enemy_killed", score_value)
			queue_free()
		else:
			health = value
			
			
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
		
	attack()
		

func attack():
	# make rotater's initial rotation in the direction of the player
	var direction = ($"../../Player".global_position - global_position).normalized()
	rotater.rotation_degrees = rad_to_deg(direction.angle())# - arc_degrees/2
	
	
	for point in rotater.get_children():
		var projectile = projectile_scene.instantiate()
		projectile.speed = projectile_speed
		var root = get_tree().get_root()
		var current_scene = root.get_child(root.get_child_count()-1)
		current_scene.add_child.call_deferred(projectile)
		projectile.position = point.global_position
		projectile.rotation = point.global_rotation
	
	

