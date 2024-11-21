@tool
extends BTAction
@export var target_var := &"target"
var ray_to_floor: RayCast2D

func _generate_name() -> String:
	return "Rush to good position, distance: %.1f" % \
	agent.get_distance_ready_to_attack()

func _enter() -> void:
	ray_to_floor = blackboard.get_var(&"ray_cast_to_floor")

func _tick(delta: float) -> Status:
	var target = blackboard.get_var(target_var) as Node2D
	var is_good_position = false
	var current_pos: Vector2 = agent.global_position
	var target_pos: Vector2 = target.global_position
	is_good_position = agent.is_good_position(current_pos, target_pos)
	
	# move to appropriate position, ready to attack
	if is_good_position:
		return SUCCESS
		
	if not ray_to_floor.is_colliding():
		return FAILURE
		
		
	# rush to the position of good distance to player where agent ready to attack
	## leave when closer to good distance, close when too far
	var current_distance = abs(target_pos.x - current_pos.x)
	var good_distance = agent.get_distance_ready_to_attack()
	var dir: int = sign(current_distance - good_distance) * agent.direction
	var speed = blackboard.get_var(&"speed")
	
	if ray_to_floor.is_colliding():
		agent.face_dir(dir)
		var velocity = agent.get_facing() * speed
		agent.move(velocity)

	return RUNNING
	
