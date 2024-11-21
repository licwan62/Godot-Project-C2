class_name MeleeAgent
extends Agent

# position with distance to player that this ready to attack
@export var good_distance := 50
@export var good_distance_range := 1
@export var desire_decelerate_speed := 50.0

func _on_die():
	anim_sprite.play(&"destroy")
	super._on_die()
	Global.scene_score += 50

func is_good_position(pos: Vector2, target_pos: Vector2) -> bool:
	var dist = abs(pos.x - target_pos.x)
	if abs(dist - good_distance) < good_distance_range:
		return true
		
	return false
	
func dash_back(dash_x_velocity: float, duration_sec: float):
	var impulse_velocity = Vector2(dash_x_velocity, 0)
	var continue_frames = duration_sec * 60
	var dir = sign(dash_x_velocity)
	var desire_decelerate_velocity = dir * desire_decelerate_speed
	
	_impulse(impulse_velocity)
	for f in range(continue_frames):
		_decelerate(desire_decelerate_velocity, .1)
		await get_tree().physics_frame
		
func attack():
	var attack = Global.Attack.new().init(
		"melee", 15, Vector2(100,-100), Vector2.LEFT * 10
	)
	
	# play animation with speed calculated by duration of attacking sprite animation 
	anim_player.speed_scale = Util.get_good_anim_speed(
		&"melee", &"hit", anim_sprite, anim_player
	)
	
	hitbox.init(attack)
	anim_player.play(&"hit")
	
func get_distance_ready_to_attack() -> float:
	return good_distance
