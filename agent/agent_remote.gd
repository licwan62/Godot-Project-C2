class_name RemoteAgent
extends Agent
@onready var muzzle: Node2D = %Muzzle
@onready var bullet_field: Node2D = %BulletField
# distance to player that this ready to attack
@export var good_distance := 100
@export var good_distance_range := 1
@export var desire_decelerated_speed := 50.0

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
	var continue_frames = duration_sec * Util.get_physics_delta()
	var dir = sign(dash_x_velocity)
	var desire_decelerated_velocity = dir * desire_decelerated_speed
	_impulse(impulse_velocity)
	
	# continue decelerating for a duration
	for f in range(continue_frames):
		_decelerate(desire_decelerated_velocity, .1)
		await get_tree().physics_frame
		
func attack():
	# setup bullet to emit
	var attack = Global.Attack.new().init(
		"shoot", 10, Vector2(100,-100), Vector2.LEFT * 10
	)
	var bullet_info = Global.BulletInfo.new().init(
		muzzle.global_position, Vector2(direction, 0), 1000
	)
	var bullet_instance = preload("res://scenes/bullet.tscn").instantiate() as Bullet
	bullet_instance.init_bullet(self, bullet_info, attack)
	
	# emit the bullet
	bullet_field.emit_signal("emit_bullet", bullet_instance)
	
	
func get_distance_ready_to_attack():
	return good_distance
