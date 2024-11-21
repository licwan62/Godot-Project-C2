extends "res://agent/player/state/limbo_state.gd"
@onready var anim_sprite: AnimatedSprite2D = %AnimatedSprite2D
@export var jump_velocity = -500
@export var can_jump = true
@export var animations: Array[StringName]
var anim_to_play: StringName
@export_group("Big Jump")
@export var can_big_jump = false
@export var counter_gravity = 8.0
@export var big_jump_duration = .5
@export var big_jump_elapse_time = 0.0
@export var key_released = false

func _enter() -> void:
	super._enter()
	
	# play jump anim depending on held weapon
	var idx = weapon_component.current_weapon
	anim_to_play = animations[idx]
	anim_sprite.play(anim_to_play)
	
	player.velocity.y = jump_velocity
	
	
func _update(delta: float) -> void:
	_handle_anim_frame()
	
	if Util.is_move_key_pressed:
		player.face_dir(Util.is_move_key_pressed)
		var velocity = player.get_facing() * player.get_current_speed()
		player.move(velocity)
	
	if is_zero_approx(player.velocity.y):
		get_root().dispatch(EVENT_FINISHED)
		
	if Input.is_action_just_pressed("dash"):
		get_root().dispatch(&"dash!")
		
	if Input.is_action_just_pressed("attack"):
		get_root().dispatch(&"attack!")
		
	if can_big_jump:
		_handle_big_jump(delta)

# set frame depending on vertical speed 
# - start, top, fall
func _handle_anim_frame():
	var progress = player.velocity.y / jump_velocity
	if progress < .5:
		anim_sprite.frame = 0
	else:
		anim_sprite.frame = 1

func _handle_big_jump(delta: float):
	if player.is_on_floor():
		big_jump_elapse_time = 0
		key_released = false
		return
	
	if Input.is_action_just_released("jump"):
		key_released = true
		return
		
	if Input.is_action_pressed("jump") and not key_released:
		big_jump_elapse_time += delta
		if big_jump_elapse_time < big_jump_duration:
			player.velocity.y -= counter_gravity
		
