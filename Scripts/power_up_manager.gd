extends Node

# progress to next power-up drop
var current_damage_progress: int = 0
var current_life_progress: int = 0

# value that must be reached to spawn the next power-up
var damage_progress_breakpoint: int = 10
var life_progress_breakpoint: int = 10

# values to manage when behavior differs from regular increments, ( noticable change to damage + size ) or max lives
var damage_upgrade_breakpoint: int = 20
var max_damage: int = 150
var max_lives: int = 5

func update_values(damage_value, life_value):
	current_damage_progress += damage_value
	current_life_progress += life_value
	
	if current_damage_progress >= damage_progress_breakpoint:
		if Globals.player_damage >= max_damage:
			Globals.score += 1000
		else:
			Globals.player_damage += 1
			
		if Globals.player_damage % damage_upgrade_breakpoint == 0:
			large_damage_upgrade()
		
		current_damage_progress = 0
	
	if current_life_progress >= life_progress_breakpoint:
		if Globals.player_lives >= max_lives:
			Globals.score += 1000
		else:
			Globals.player_lives += 1
		current_life_progress = 0
	
func large_damage_upgrade():
	# increase size, perhaps shooting speed (maybe), change particle effects, etc...
	# if we want this to actually increase the player_damage, then enemy health has to be reworked.
	
	pass
