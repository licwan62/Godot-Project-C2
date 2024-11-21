extends BTAction

@export var target_var := &"target"
@export var facing = true
var target: Node2D

func _enter() -> void:
	target = blackboard.get_var(target_var)

func _tick(delta: float) -> Status:
	var sign = 1 if facing else -1
	var dir = sign(target.global_position.x - agent.global_position.x)
	agent.face_dir(sign * dir)
	return SUCCESS
