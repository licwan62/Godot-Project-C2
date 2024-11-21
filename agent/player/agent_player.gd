class_name Player
extends Agent
signal hit_ground
@onready var ray_cast_to_floor: RayCast2D = $RayCastToFloor
@onready var ray_cast_to_enemy: RayCast2D = $RayCastToEnemy
@onready var attack_state: AttackState = %Attack
@onready var muzzle: Node2D = %Muzzle
@onready var bullet_field: Node2D = %BulletField
@export var basic_speed = 300.0
## determine actual speed = rate * basic speed
@export_enum("WALK", "RUN") var move_action: int = 0
@export var run_speed_rate := 1.5
@export var sprint_speed_rate := 3.0

var actions_in_queue = 0
var is_dashing = false
var is_floating = false
var is_slashing_down = false
var was_on_floor: bool
	
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_handle_player_hit_ground()
	if is_dashing:
		_decelerate(direction * basic_speed, .1)
		velocity.y = 0
		gravity = Vector2.ZERO
		
	if is_floating:
		gravity = Vector2.ZERO
		velocity.y = 0
		
	if is_slashing_down:
		gravity = get_gravity() * 5
		Util.pause_animation_at_frame(anim_sprite, anim_sprite.animation, 2)
	
func _handle_player_hit_ground():
	if is_on_floor() and not was_on_floor:
		emit_signal("hit_ground")
	was_on_floor = is_on_floor()
	
func _impulse(_velocity: Vector2):
	velocity = _velocity
	move_this_frame = true
			
func _on_die():
	anim_sprite.play(&"destroy")
	super._on_die()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func dash(_speed: float, duration: float):
	var impulse_velocity = Vector2(direction * _speed, 0) 
	_impulse(impulse_velocity)
	is_dashing = true
	await get_tree().create_timer(duration).timeout
	is_dashing = false
	
func slash_up(_speed: float):
	await get_tree().create_timer(.2).timeout
	var impulse_velocity = Vector2(0, -_speed)
	_impulse(impulse_velocity)
	
func slash_down(_speed: float):
	velocity = Vector2(0, _speed)
	is_slashing_down = true
	await hit_ground
	is_slashing_down = false
	anim_sprite.play()
	print("slash down the ground")
	
func float_in_air(duration: float):
	is_floating = true
	actions_in_queue += 1
	await get_tree().create_timer(duration).timeout
	actions_in_queue -= 1
	if actions_in_queue == 0:
		is_floating = false
		
# set hitbox enable duration - when attack anim finished, hitbox collision turns inactive
func melee_attack(attack: Global.Attack):
	assert(Global.active_state == attack_state, "attack state not active")
	
	var sprite_anim = attack_state.get_playing_animation()
	anim_player.speed_scale = Util.get_good_anim_speed(
		sprite_anim, &"hit", anim_sprite, anim_player
	)
	anim_player.play(&"hit")
	
	# parse attack to hitbox for attackee hurtbox to get
	hitbox.init(attack)
	
func remote_attack():
	# setup bullet to emit
	var attack = Global.Attack.new().init(
		"shoot", 10, Vector2(100,-100), Vector2.LEFT * 10
	)
	var bullet = Global.BulletInfo.new().init(
		muzzle.global_position, Vector2(direction, 0), 1000
	)
	var bullet_instance = preload("res://scenes/bullet.tscn").instantiate() as Bullet
	bullet_instance.init_bullet(self, bullet, attack)
	
	# emit the bullet
	bullet_field.emit_signal("emit_bullet", bullet_instance)
	
	
func get_height_over_ground() -> float:
	if not ray_cast_to_floor.is_colliding():
		return -1 # too high, floor not detected
		
	var ground_point = ray_cast_to_floor.get_collision_point()
	var height = global_position.distance_to(ground_point)
	# DEBUG output height on attacking
	#print("current height: %f" % height)
	return height
	
func detect_enemy_beneath() -> bool:
	if not ray_cast_to_enemy.is_colliding():
		return false
	var detected_enemy := ray_cast_to_enemy.get_collider() as CharacterBody2D
	if detected_enemy == null:
		return false
	return true
	
func get_current_speed(): 
	match move_action:
		0: return basic_speed
		1: return run_speed_rate * basic_speed
		2: return sprint_speed_rate * basic_speed
		
func player_transform(destination_pos: Vector2):
	position = destination_pos
	var attack_se = "res://music/Item3.ogg"
	SoundManager.play_se(attack_se)
