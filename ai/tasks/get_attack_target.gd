extends BTAction

@export var target_var := &"target"
var ray_to_player: RayCast2D

func _enter() -> void:
	ray_to_player = blackboard.get_var(&"ray_cast_to_player")
	
		
func _tick(delta: float) -> Status:
	if ray_to_player.is_colliding():
		blackboard.set_var(target_var, ray_to_player.get_collider())
		return SUCCESS
	return FAILURE
