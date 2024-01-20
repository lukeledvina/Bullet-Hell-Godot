extends Node

@onready var damage_number_label: Label = $"../UserInterface/MarginContainer/PowerUpContainer/DamagePowerUpContainer/DamageNumber"
@onready var life_progress_label: Label = $"../UserInterface/MarginContainer/PowerUpContainer/LifePowerUpContainer/LifeProgressNumber"
@onready var score_number_label: Label = $"../UserInterface/MarginContainer/MainContainer/ScoreContainer/ScoreNumber"
@onready var lives_number_label: Label = $"../UserInterface/MarginContainer/MainContainer/LivesContainer/LivesNumber"

var damage_power_up_scene: PackedScene = preload("res://Scenes/PowerUps/damage_power_up.tscn")
var life_power_up_scene: PackedScene = preload("res://Scenes/PowerUps/life_power_up.tscn")

# progress to next power-up drop
var current_damage_progress: int = 0
var current_life_progress: int = 0

# value that must be reached to spawn the next power-up
var damage_progress_breakpoint: int = 10
var life_progress_breakpoint: int = 15

# values to manage when behavior differs from regular increments, ( noticable change to damage + size ) or max lives
var next_life_progress: int = 0
var next_life_breakpoint: int = 5
var damage_upgrade_breakpoint: int = 20
var max_damage: int = 200
var max_lives: int = 5

#spawn the amt of each power up, in locations not overlapping
func boss_killed(boss_position, damage_power_up_amount, life_power_up_amount):
	var x_offset: int = -40
	var y_offset: int = -40
	for i in range(damage_power_up_amount):
		if i != 2:
			var damage_power_up = damage_power_up_scene.instantiate()
			damage_power_up.global_position = Vector2(boss_position.x + x_offset, boss_position.y + y_offset)
			call_deferred("add_child", damage_power_up)
			damage_power_up.connect("collected", _on_damage_power_up_collected)
			x_offset += 20
			y_offset += 20
		else:
			x_offset += 20
			y_offset += 20
	
	x_offset = -40
	y_offset = 40
	for i in range(life_power_up_amount):
		var life_power_up = life_power_up_scene.instantiate()
		life_power_up.global_position = Vector2(boss_position.x + x_offset, boss_position.y + y_offset)
		call_deferred("add_child", life_power_up)
		life_power_up.connect("collected", on_life_power_up_collected)
		x_offset += 20
		y_offset -= 20

func update_values(damage_value, life_value, enemy_position):
	current_damage_progress += damage_value
	current_life_progress += life_value
	
	if current_damage_progress >= damage_progress_breakpoint:
		current_damage_progress = 0
		var damage_power_up = damage_power_up_scene.instantiate()
		damage_power_up.global_position = enemy_position
		call_deferred("add_child", damage_power_up)

		damage_power_up.connect("collected", _on_damage_power_up_collected)
		return
	
	if current_life_progress >= life_progress_breakpoint:
		current_life_progress = 0
		var life_power_up = life_power_up_scene.instantiate()
		life_power_up.global_position = enemy_position
		call_deferred("add_child", life_power_up)
		
		life_power_up.connect("collected", on_life_power_up_collected)
		
	
	
func _on_damage_power_up_collected():
	if Globals.player_damage >= max_damage:
		Globals.score += 1000
		score_number_label.text = str(Globals.score)
	else:
		Globals.player_damage += 1
		
	if Globals.player_damage % damage_upgrade_breakpoint == 0:
		large_damage_upgrade()
		
	damage_number_label.text = str(Globals.player_damage)
	
	current_damage_progress = 0
	

func on_life_power_up_collected():
	# increment until reaching 10, then add a life
	next_life_progress += 1
	# update the UI
	
	if next_life_progress % next_life_breakpoint == 0:
		next_life_progress = 0
		if Globals.player_lives >= max_lives:
			Globals.score += 1000
			score_number_label.text = str(Globals.score)
		else:
			Globals.player_lives += 1
			lives_number_label.text = str(Globals.player_lives)
			
	life_progress_label.text = "%d / 5" % next_life_progress
	

func large_damage_upgrade():
	Globals.player_projectile_scale += 0.1
