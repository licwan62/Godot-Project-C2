@tool
extends BTAction

func _generate_name() -> String:
	return "MoveForward speed: %.0f" % blackboard.get_var(&"speed")

func _tick(delta: float) -> Status:
	var speed: float = blackboard.get_var(&"speed", 100.0)
	
	if agent.is_on_floor():
		var velocity = agent.get_facing() * speed
		agent.move(velocity)
	
	return RUNNING
