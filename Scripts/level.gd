extends Node2D
class_name Level

var offset: Vector2 = Vector2.ZERO
var floaty_path_1_offset: Vector2 = Vector2(300, 0)
var parallel_offset: Vector2 = Vector2(30, -30)

var boss_center_position: Vector2 = Vector2(640, 160)

var floaty: PackedScene = preload("res://Scenes/Enemies/floaty.tscn")
var floaty_path_1: PackedScene = preload("res://Scenes/EnemyPaths/floaty_path_1.tscn")

var eddy: PackedScene = preload("res://Scenes/Enemies/eddy.tscn")
var eddy_path_1: PackedScene = preload("res://Scenes/EnemyPaths/eddy_path_1.tscn")

var evil_floaty: PackedScene = preload("res://Scenes/Enemies/evil_floaty.tscn")

@onready var player: CharacterBody2D = $Game/Player
@onready var score_number_label: Label = $UserInterface/MarginContainer/MainContainer/ScoreContainer/ScoreNumber
@onready var lives_number_label: Label = $UserInterface/MarginContainer/MainContainer/LivesContainer/LivesNumber
@onready var damage_power_up_label: Label = $UserInterface/MarginContainer/PowerUpContainer/DamagePowerUpContainer/DamageNumber
@onready var life_power_up_label: Label = $UserInterface/MarginContainer/PowerUpContainer/LifePowerUpContainer/LifeProgressNumber
@onready var game: Node2D = $Game
@onready var enemy_projectile_container: Node2D = $Game/EnemyProjectiles
@onready var borders: Node2D = $UserInterface/Borders
@onready var enemy_paths: Node2D = $Game/EnemyPaths
@onready var power_up_manager: Node = $PowerUpManager

var game_scroll_speed: int = 1

var floaty_time: float = 0.2
var eddy_time: float = 0.3

func _ready():
	borders.visible = true

func _process(delta):
	game.global_position.y -= game_scroll_speed * delta


func _on_enemy_killed(score_value, damage_power_up_progress, life_power_up_progress, enemy_position):
	Globals.score += score_value
	score_number_label.text = str(Globals.score)

	# increment values needed to spawn the power ups, if the values are reached, spawn them
	power_up_manager.update_values(damage_power_up_progress, life_power_up_progress, enemy_position)

func _on_boss_killed(boss_position, damage_power_up_amount, life_power_up_amount):
	power_up_manager.boss_killed(boss_position, damage_power_up_amount, life_power_up_amount)


func _on_enemy_projectile_created(projectile):
	projectile.connect("player_killed", _on_player_killed)


func _on_player_killed():
	for projectile in enemy_projectile_container.get_children():
		projectile.queue_free()
	
	player.death()
	lives_number_label.text = str(Globals.player_lives)

func spawn_enemies(enemy_type: PackedScene, amount: int, path_scene: PackedScene, reverse: bool, path_offset: Vector2, time_between: float):
	var path = path_scene.instantiate()
	enemy_paths.add_child(path)
	if reverse:
		path_reverse(path)
		path.position.x -= path_offset.x
		path.position.y += path_offset.y
	else:
		path.position += path_offset
	path.position.x += 640
	
	for i in range(amount):
		var path_follow: PathFollow2D = PathFollow2D.new()
		path_follow.rotates = false
		path_follow.loop = false
		var new_enemy: CharacterBody2D = enemy_type.instantiate()
		path_follow.add_child(new_enemy)
		new_enemy.connect("enemy_killed", _on_enemy_killed)
		new_enemy.connect("enemy_projectile_created", _on_enemy_projectile_created)
		path.call_deferred("add_child", path_follow)
		
		new_enemy.attack_point = path.attack_point
		
		await get_tree().create_timer(time_between).timeout
	
	# free the path after x seconds
	await get_tree().create_timer(25).timeout
	path.queue_free()

func path_reverse(path: Path2D):
	var new_curve: Curve2D = Curve2D.new()
	var points = path.curve.get_baked_points()
	#path.curve.clear_points()
	for point in points:
		var new_point = point.reflect(Vector2.UP)
		new_curve.add_point(new_point)
	path.curve = new_curve
	return path
	
