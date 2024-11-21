@tool
extends BTAction

var ray_to_floor: RayCast2D

func _enter() -> void:
	ray_to_floor = blackboard.get_var(&"ray_cast_to_floor")

func _tick(delta: float) -> Status:
	if not ray_to_floor.is_colliding() and agent.is_on_floor():
		#print_debug("lost detected floor, turn over")
		agent.turn_dir()
		
	return RUNNING
