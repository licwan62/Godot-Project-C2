@tool
extends BTCondition
## DetectTarget

var ray_to_player: RayCast2D
@export var output_var := &"target"

# Display a customized name (requires @tool).
func _generate_name() -> String:
	return "DetectTarget"

# Called each time this task is entered.
func _enter() -> void:
	ray_to_player = blackboard.get_var(&"ray_cast_to_player")

# Called each time this task is ticked (aka executed).
func _tick(delta: float) -> Status:
	if ray_to_player.is_colliding():
		var colliding_player = ray_to_player.get_collider()
		if colliding_player is Player:
			blackboard.set_var(output_var, colliding_player)
			return SUCCESS
		
	return RUNNING
