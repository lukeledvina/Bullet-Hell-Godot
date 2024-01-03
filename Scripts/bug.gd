extends Enemy

func _ready():
	var starting_pos = global_position
	$AnimationPlayer.play("movement")
	global_position = starting_pos


func attack():
	direction = ($"../../Player".global_position - global_position).normalized()
	emit_signal("enemy_shooting", global_position, direction)
	print(direction)
	
