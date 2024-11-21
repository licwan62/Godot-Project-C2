@tool
extends BTAction

@export var dash_speed := 500
@export var dash_duration_sec := 1
@export var desire_dash_distance := 100.0
var ray_to_floor: RayCast2D
var original_x_pos: float

func _generate_name() -> String:
	return "Dash back, impulse speed: %.1f, duration: %.1f" % \
		[dash_speed, dash_duration_sec]

func _enter() -> void:
	ray_to_floor = blackboard.get_var(&"ray_cast_to_floor")
	original_x_pos = agent.global_position.x

func _tick(delta: float) -> Status:
	# dash back to distance further than disired
	var current_x_pos = agent.global_position.x
	var dash_dist = abs(current_x_pos - original_x_pos)
	if dash_dist >= desire_dash_distance:
		return SUCCESS
		
	# dash back
	var dash_x_velocity = -agent.get_facing() * dash_speed
	agent.dash_back(dash_x_velocity, dash_duration_sec)
	return RUNNING
